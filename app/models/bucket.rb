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

class Bucket < ActiveRecord::Base
  belongs_to :account

  #Priority determines which bucket funds are pulled from first.
  #Funds will be drawn from a priority 2 bucket before a priority 1 bucket
  #Needs a validation on name, where name is unique on a per account basis

  #Name matchers must downcase all the things
end
