# == Schema Information
#
# Table name: buckets
#
#  id         :integer          not null, primary key
#  name       :string
#  amount     :float
#  account_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Bucket, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
