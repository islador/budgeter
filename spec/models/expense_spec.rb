# == Schema Information
#
# Table name: expenses
#
#  id         :integer          not null, primary key
#  name       :string
#  amount     :integer          default("0")
#  account_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  bucket_id  :integer
#

require 'rails_helper'

RSpec.describe Expense, :type => :model do
  describe "After creation" do
    let(:account) { FactoryGirl.create(:account) }

    it "sends itself to account" do
      expect(account).to receive(:expense)
      account.expenses.create(name: "Test Expense", amount: 300.25)
    end
  end
end
