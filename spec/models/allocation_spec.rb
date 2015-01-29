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

require 'rails_helper'

RSpec.describe Allocation, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
