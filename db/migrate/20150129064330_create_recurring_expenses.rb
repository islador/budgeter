class CreateRecurringExpenses < ActiveRecord::Migration
  def change
    create_table :recurring_expenses do |t|
      t.string :name
      t.float :amount
      t.integer :priority
      t.integer :bucket_id
      t.integer :account_id

      t.timestamps null: false
    end
  end
end
