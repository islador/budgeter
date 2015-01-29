# == Schema Information
#
# Table name: incomes
#
#  id         :integer          not null, primary key
#  name       :string
#  amount     :integer          default("0")
#  origin     :string
#  account_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Income, :type => :model do

  let(:account) { FactoryGirl.create(:account) }

  describe "After creation" do
    it "sends itself to account" do
      expect(account).to receive(:allocate)
      account.incomes.create(name: "Paycheck", amount: 400.25, origin: "Work")
    end
  end
end
