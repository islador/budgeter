# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  name       :string
#  total      :integer          default("0")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Account, :type => :model do
  let(:account) { FactoryGirl.create(:account, total: 0) }

  describe "#allocate" do
    let(:income) { FactoryGirl.create(:income, account: account, amount: 550) }
    let!(:savings) { FactoryGirl.create(:allocation, account: account, amount: 250, name: "Savings", priority: 2) }
    let!(:savings_bucket) { FactoryGirl.create(:bucket, account: account, name: "savings") }
    let!(:rent) { FactoryGirl.create(:allocation, account: account, amount: 250, name: "Rent", priority: 1) }
    let!(:rent_bucket) { FactoryGirl.create(:bucket, account: account, name: "rent") }

    before do
      Income.skip_callback(:create, :after, :notify_account)
    end

    after do
      Income.set_callback(:create, :after, :notify_account)
    end

    it "updates account" do
      account.allocate(income)
      account.reload
      expect(account.total).to be 550
    end

    context "with sufficient funds " do
      it "apportions each allocation's amount to the matching bucket" do
        account.allocate(income)
        savings_bucket.reload
        rent_bucket.reload
        expect(savings_bucket.amount).to be 250
        expect(rent_bucket.amount).to be 250
      end
    end

    context "with insufficient funds" do
      let!(:spending_cash) { FactoryGirl.create(:allocation, account: account, amount: 250, name: "Spending Cash", priority: 3) }
      let!(:spending_cash_bucket) { FactoryGirl.create(:bucket, account: account, name: "spending cash")}

      it "apportions money by priority until it runs out" do
        account.allocate(income)
        savings_bucket.reload
        rent_bucket.reload
        spending_cash_bucket.reload
        expect(savings_bucket.amount).to be 250
        expect(rent_bucket.amount).to be 250
        expect(spending_cash_bucket.amount).to be 50
      end
    end

    context "with exactly sufficient funds" do
      let!(:spending_cash) { FactoryGirl.create(:allocation, account: account, amount: 50, name: "Spending Cash", priority: 3) }
      let!(:spending_cash_bucket) { FactoryGirl.create(:bucket, account: account, name: "spending cash")}

      it "apportions money by priority until it runs out" do
        account.allocate(income)
        savings_bucket.reload
        rent_bucket.reload
        spending_cash_bucket.reload
        expect(savings_bucket.amount).to be 250
        expect(rent_bucket.amount).to be 250
        expect(spending_cash_bucket.amount).to be 50
      end
    end
  end

  describe "#subtract_expense" do
    let(:account) { FactoryGirl.create(:account, total: 500) }
    let!(:savings) { FactoryGirl.create(:bucket, account: account, amount: 250, priority: 1, name: "savings") }
    let!(:emergency) { FactoryGirl.create(:bucket, account: account, amount: 200, priority: 2, name: "emergency") }
    let!(:spending_cash) { FactoryGirl.create(:bucket, account: account, amount: 50, priority: 3, name: "spending_cash") }

    before do
      Income.skip_callback(:create, :after, :notify_account)
      Expense.skip_callback(:create, :after, :notify_account)
    end

    after do
      Income.set_callback(:create, :after, :notify_account)
      Expense.set_callback(:create, :after, :notify_account)
    end

    context "there is no target bucket" do
      let(:expense) { FactoryGirl.create(:expense, account: account, amount: 450, bucket_id: nil) }
      it "removes funds from the lowest to highest priority bucket until the expense is paid" do
        account.subtract_expense(expense)
        savings.reload
        emergency.reload
        spending_cash.reload

        expect(spending_cash.amount).to eq 0
        expect(emergency.amount).to eq 0
        expect(savings.amount).to eq 50
      end

      it "updates the account total" do
        account.subtract_expense(expense)
        expect(account.total).to eq 50
      end
    end

    context "there are insufficent funds in the target bucket" do
      let(:expense) { FactoryGirl.create(:expense, account: account, amount: 225, bucket_id: emergency.id) }
      it "removes all funds from the target bucket" do
        account.subtract_expense(expense)
        emergency.reload
        expect(emergency.amount).to eq 0
      end

      it "removes the remainder of the expense's amount from the lowest to highest priority bucket until the expense is paid" do
        account.subtract_expense(expense)
        savings.reload
        emergency.reload
        spending_cash.reload

        expect(savings.amount).to eq 250
        expect(emergency.amount).to eq 0
        expect(spending_cash.amount).to eq 25
      end

      it "updates the account total" do
        account.subtract_expense(expense)
        account.reload
        expect(account.total).to eq 275
      end
    end

    context "there are sufficient funds in the target bucket" do
      let(:expense) { FactoryGirl.create(:expense, account: account, amount: 225, bucket_id: savings.id) }
      it "removes the expense's amount from the target bucket" do
        account.subtract_expense(expense)
        savings.reload
        expect(savings.amount).to eq 25
      end

      it "updates the account total" do
        account.subtract_expense(expense)
        account.reload
        expect(account.total).to eq 275
      end
    end
  end
end
