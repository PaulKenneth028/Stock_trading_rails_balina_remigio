class StockTransactionsController < ApplicationController
  before_action :authenticate_user!

  def create
    stock_symbol = params[:stock_transaction][:stock_symbol]
    amount = params[:stock_transaction][:amount].to_i
    stock = Stock.find_by(symbol: stock_symbol)

    if stock.present?
      latest_price = get_stock_price(stock_symbol)

      if latest_price.present?
        user = current_user
        transaction_type = params[:transaction_type]

        if transaction_type == 'buy' && user.balance >= amount * latest_price
          create_buy_transaction(user, stock, amount, latest_price)
          flash[:notice] = 'Stock purchase successful.'
          debugger
          redirect_to root_path(stock_symbol: stock_symbol, transaction_type: 'buy')
        elsif transaction_type == 'sell' && user.stock_balance(stock) >= amount
          create_sell_transaction(user, stock, amount, latest_price)
          flash[:notice] = 'Stock sale successful.'
          debugger
          redirect_to root_path(stock_symbol: stock_symbol, transaction_type: 'sell')
        else
          flash[:alert] = 'Insufficient funds or stocks.'
          debugger
          redirect_to root_path
        end
      else
        flash[:alert] = 'Failed to fetch stock price.'
        debugger
        redirect_to root_path
      end
    else
      flash[:alert] = 'Stock not found.'
      debugger
      redirect_to root_path
    end
  end

  private

  def get_stock_price(symbol)
    iex_service = IexService.new('pk_3dbda283b9094177a492240a433bafa8')
    stock_data = iex_service.stock_quote(symbol)

    return stock_data['latestPrice'] if stock_data.present?
    nil
  end

  def create_buy_transaction(user, stock, amount, latest_price)
    StockTransaction.create(
      user: user,
      transaction_type: 'buy',
      stock: stock,
      amount: amount,
      stock_price: latest_price
    )
    user.update(balance: user.balance - amount * latest_price)

    @user_stocks = current_user.stocks_owned

    respond_to do |format|
      format.js { render partial: 'shared/update_portfolio_section', locals: { user_stocks: @user_stocks } }
    end
  end

  def create_sell_transaction(user, stock, amount, latest_price)
    # Add logic for selling transaction if needed
    # Similar to the create_buy_transaction method
  end
end
