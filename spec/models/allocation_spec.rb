# == Schema Information
#
# Table name: allocations
#
#  id         :integer          not null, primary key
#  name       :string
#  amount     :integer          default("0")
#  account_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  priority   :integer          default("0")
#

require 'rails_helper'

RSpec.describe Allocation, :type => :model do
  describe "After creation" do
    let(:account) { FactoryGirl.create(:account) }

    it "creates a bucket with the same name and the same account" do
      account.allocations.create(name: "Savings")
      expect(account.buckets[0].name).to eq "Savings"
    end
  end
end
