class CreateStockTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :stock_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :stock_symbol
      t.string :transaction_type
      t.decimal :latest_price
      t.integer :amount

      t.timestamps
    end
  end
end
