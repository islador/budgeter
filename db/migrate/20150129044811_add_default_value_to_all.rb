class AddDefaultValueToAll < ActiveRecord::Migration
  def up
    change_column :accounts, :total, :integer, default: 0
    change_column :allocations, :amount, :integer, default: 0
    change_column :buckets, :amount, :integer, default: 0
    change_column :expenses, :amount, :integer, default: 0
    change_column :incomes, :amount, :integer, default: 0
  end

  def down
    change_column :accounts, :total, :integer
    change_column :allocations, :amount, :integer
    change_column :buckets, :amount, :integer
    change_column :expenses, :amount, :integer
    change_column :incomes, :amount, :integer
  end
end
