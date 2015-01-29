# == Schema Information
#
# Table name: expenses
#
#  id         :integer          not null, primary key
#  name       :string
#  amount     :float
#  account_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Expense < ActiveRecord::Base
end
