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

require 'rails_helper'

RSpec.describe RecurringExpense, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
