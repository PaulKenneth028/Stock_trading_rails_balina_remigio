class AddStockToStockTransactions < ActiveRecord::Migration[7.1]
  def change
    add_column :stock_transactions, :stock, :string
  end
end
