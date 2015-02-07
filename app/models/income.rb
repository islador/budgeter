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

class Income < ActiveRecord::Base
  belongs_to :account

  after_create :notify_account

  private
    def notify_account
      self.account.income(self)
    end
end
