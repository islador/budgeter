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

class Expense < ActiveRecord::Base
  belongs_to :account

  after_create :notify_account

  private
    def notify_account
      self.account.expense(self)
    end
end
