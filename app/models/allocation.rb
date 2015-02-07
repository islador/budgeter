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

class Allocation < ActiveRecord::Base
  belongs_to :account

  after_create :build_bucket

  private
    def build_bucket
      self.account.buckets.create(name: self.name)
    end
end
