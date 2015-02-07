class AddBucketIDtoExpense < ActiveRecord::Migration
  def up
    add_column :expenses, :bucket_id, :integer
  end
  def down
    remove_column :expenses, :bucket_id
  end
end
