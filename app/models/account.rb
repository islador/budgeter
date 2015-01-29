# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  name       :string
#  total      :integer          default("0")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Account < ActiveRecord::Base

  has_many :allocations
  has_many :buckets
  has_many :expenses
  has_many :incomes

  def allocate(income)
    #This can be refactored to use IDs, assuming buckets are made when allocations are made.
    allocations = self.allocations.pluck("priority","amount","name")
    # Sort the allocations into priority order
    allocations.sort_by!{|i| i[0]}
    # Allocate funds to each bucket & update the account total
    allocations.each do |a|
      if income.amount - a[1] > 0
        # Handles amounts that can be fully allocated
        bucket = self.buckets.where(name: a[2].downcase)[0]
        bucket.amount += a[1]
        bucket.save
        self.total += a[1]
        income.amount -= a[1]
      else income.amount - a[1] < 0
        # Handles amounts that exceed the income
        bucket = self.buckets.where(name: a[2].downcase)[0]
        remainder = (a[1] - (income.amount - a[1]).abs)
        bucket.amount += remainder
        bucket.save
        self.total += remainder
        break
      end
    end

    # Ensure any unallocated funds are added to the account's total
    if income.amount != 0
      self.total += income.amount
    end
    save
  end

  def subtract_expense(expense)
    buckets = self.buckets.pluck("id","priority","amount")
    # Sort by priority
    buckets.sort_by!{|i|, i[1]}

    # If a target bucket is specified, insert that bucket at the front
    if expense.bucket_id.present?
      bucket = Bucket.find(expense.bucket_id).pluck("id","priority","amount")
      buckets.insert(0, bucket)
    end

    i = 0
    while expense.amount > 0
      unless
      if buckets[i][2] >= expense.amount
        buckets[i][2]
      buckets[i].

      i++
    buckets.each do |b|
      if b[2] - expense.amount > 0

  end
end
