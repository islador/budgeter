# == Schema Information
#
# Table name: incomes
#
#  id         :integer          not null, primary key
#  name       :string
#  amount     :float
#  origin     :string
#  account_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Income < ActiveRecord::Base
end
