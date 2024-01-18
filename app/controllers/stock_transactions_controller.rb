class StockTransactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    stock_symbol = params[:stock_transaction][:stock_symbol]
    amount = params[:stock_transaction][:amount].to_i
    stock_price = get_stock_price(stock_symbol)

    if stock_price.present?
      user = current_user
      transaction_type = params[:transaction_type]

      if transaction_type == 'buy' && user.balance >= amount * stock_price
        create_buy_transaction(user, stock_symbol, amount, stock_price)
        flash[:notice] = 'Stock purchase successful.'
        debugger  # <-- Retained debugger
        redirect_to root_path(stock_symbol: stock_symbol, transaction_type: 'buy')
      elsif transaction_type == 'sell' && user.stock_balance(stock_symbol) >= amount
        create_sell_transaction(user, stock_symbol, amount, stock_price)
        flash[:notice] = 'Stock sale successful.'
        debugger  # <-- Retained debugger
        redirect_to root_path(stock_symbol: stock_symbol, transaction_type: 'sell')
      else
        flash[:alert] = 'Insufficient funds or stocks.'
        debugger  # <-- Retained debugger
        redirect_to root_path
      end
    else
      flash[:alert] = 'Failed to fetch stock price.'
      debugger  # <-- Retained debugger
      redirect_to root_path
    end
  end

  private

  def get_stock_price(symbol)
    iex_service = IexService.new('pk_3dbda283b9094177a492240a433bafa8')  # replace with your actual API key
    stock_data = iex_service.stock_quote(symbol)

    return stock_data['latestPrice'] if stock_data.present?
    nil
  end

  def create_buy_transaction(user, stock_symbol, amount, stock_price)
    stock = Stock.find_by(symbol: stock_symbol)

    if stock.present?
      StockTransaction.create(
        user: user,
        transaction_type: 'buy',
        stock: stock,
        amount: amount,
        stock_price: stock_price
      )
      user.update(balance: user.balance - amount * stock_price)

      @user_stocks = current_user.stocks_owned

      respond_to do |format|
        format.js { render partial: 'shared/update_portfolio_section', locals: { user_stocks: @user_stocks } }
      end
    else
      flash[:alert] = 'Stock not found.'
      redirect_to root_path
    end
  end

  def create_sell_transaction(user, stock_symbol, amount, stock_price)
    # Add logic for selling transaction if needed
    # Similar to the create_buy_transaction method
  end
end
