# == Schema Information
#
# Table name: buckets
#
#  id         :integer          not null, primary key
#  name       :string
#  amount     :integer          default("0")
#  account_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  priority   :integer          default("0")
#

require 'rails_helper'

RSpec.describe Bucket, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
