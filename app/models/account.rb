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
  has_many :recurring_expenses

  def expense(expense)
    subtract_expense(expense)
  end

  def income(income)
    allocate(income)
  end

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
    # If a target bucket is specified, insert that bucket at the front
    if expense.bucket_id.present?
      buckets = self.buckets.where("id not in (?)", [expense.bucket_id]).pluck("id","priority","amount")
      # Sort by priority
      buckets.sort_by!{|i| -i[1]}

      # Inject the target bucket at the front
      buckets.insert(0, Bucket.where("id = ?", expense.bucket_id).pluck("id","priority","amount").flatten)
    else
      buckets = self.buckets.pluck("id","priority","amount")
      # Sort by priority
      buckets.sort_by!{|i| -i[1]}
    end

    # Iterate through each bucket until the expense has been drained.
    buckets.each do |b|
      # If a bucket has less money than the expense requires
      if b[2] < expense.amount
        # Subtract the bucket's amount from the expense's amount
        expense.amount = expense.amount - b[2]
        # Retrieve the bucket
        bucket = Bucket.find(b[0])
        # Drain the bucket
        bucket.amount -= b[2]
        # Update the account's total
        self.total -= b[2]
        # Save the bucket
        bucket.save
      elsif b[2] > expense.amount
        # The bucket must have more money than the expense requires.
        # Retrieve the bucket
        bucket = Bucket.find(b[0])
        # Remove the expense from the bucket
        bucket.amount -= expense.amount
        # Update the account's total
        self.total -= expense.amount
        # Save the bucket
        bucket.save
        # Break the loop
        break
      else
        # All buckets have been drained except the last one, which must be allowed to go negative.
        # Retrieve the bucket
        bucket = Bucket.find(b[0])
        # Subtract the expense from the bucket
        bucket.amount -= expense.amount
        # Update the account's total
        self.total -= expense.amount
        # Save the bucket
        bucket.save
      end
    end
    #Save the account's new
    save
  end
end
