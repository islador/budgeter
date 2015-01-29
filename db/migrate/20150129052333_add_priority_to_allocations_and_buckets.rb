class AddPriorityToAllocationsAndBuckets < ActiveRecord::Migration
  def up
    add_column :buckets, :priority, :integer, default: 0
    add_column :allocations, :priority, :integer, default: 0
  end
  def down
    remove_column :buckets, :priority
    remove_column :allocations, :priority
  end
end
