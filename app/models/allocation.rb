# == Schema Information
#
# Table name: allocations
#
#  id         :integer          not null, primary key
#  name       :string
#  amount     :float
#  account_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Allocation < ActiveRecord::Base
end
