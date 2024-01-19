class StockTransactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    stock_symbol = params[:stock_transaction][:stock_symbol]
    amount = params[:stock_transaction][:amount]

    user_balance = current_user.balance
    stock_data = get_stock_data(stock_symbol)

    if stock_data.present?
      transaction_type = params[:stock_transaction][:transaction_type]
      stock_price = stock_data['latestPrice']
      total_transaction_cost = amount.to_f * stock_price

      Rails.logger.debug "Transaction Type: #{transaction_type.inspect}"
      Rails.logger.debug "User ID: #{current_user.id}"
      Rails.logger.debug "Stock Symbol: #{stock_symbol}"
      Rails.logger.debug "Amount: #{amount}"
      Rails.logger.debug "User Balance: #{current_user.balance}"

      if transaction_type.to_s.downcase == 'buy' && user_balance >= total_transaction_cost
        create_buy_transaction(current_user, stock_symbol, amount.to_f, stock_data)
        render json: { success: true, message: 'Stock purchase successful.' }
      else
        render json: { success: false, message: 'Insufficient funds or invalid transaction.' }
      end
    else
      flash[:alert] = 'Failed to fetch stock data.'
      redirect_to root_path
    end
  end
  private

  def get_stock_data(symbol)
    iex_service = IexService.new('pk_3dbda283b9094177a492240a433bafa8')
    iex_service.stock_quote(symbol)
  end

  def create_buy_transaction(user, stock_symbol, amount, stock_data)
    stock = Stock.find_or_create_by(symbol: stock_symbol)

    StockTransaction.create(
      user: user,
      transaction_type: 'buy',
      stock: stock,
      amount: amount,
      stock_price: stock_data['latestPrice']
    )

    user.update(balance: user.balance - amount * stock_data['latestPrice'])
    @user_stocks = user.stocks_owned

    respond_to do |format|
      format.js { render partial: 'shared/update_portfolio_section', locals: { user_stocks: @user_stocks } }
    end
  end
end