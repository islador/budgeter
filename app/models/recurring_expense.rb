# == Schema Information
#
# Table name: recurring_expenses
#
#  id         :integer          not null, primary key
#  name       :string
#  amount     :float
#  priority   :integer
#  bucket_id  :integer
#  account_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class RecurringExpense < ActiveRecord::Base
  belongs_to :account
end
