class AddStockTransactionIdToStocks < ActiveRecord::Migration[7.1]
  def change
    add_reference :stocks, :stock_transaction, null: false, foreign_key: true
  end
end
