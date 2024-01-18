# app/controllers/stocks_controller.rb

class StocksController < ApplicationController
    def show
      @symbol = params[:symbol]
      session[:current_stock_symbol] = @symbol
      # Fetching company information
      company_info = IEX::Resources::Company.get(@symbol)
      @company_name = company_info.company_name
      
      # Fetching quote information
      quote = IEX::Resources::Quote.get(@symbol)
      @price = quote.latest_price
      @one_day_change = quote.change
  
      # You can add more information as needed
      
      # Example: Fetching additional information like the previous close
      @previous_close = quote.previous_close
  
      # Example: Fetching historical prices (for illustration purposes)
      @historical_prices = IEX::Endpoints::Stock::Chart.range(@symbol, '1m', { chartCloseOnly: true })
    end

    def buy
      @user = current_user
      @symbol = params[:symbol]
      @quantity = params[:quantity].to_i
  
      quote = IEX::Resources::Quote.get(@symbol)
      stock_price = quote.latest_price
  
      total_cost = stock_price * @quantity

      if @user.balance >= total_cost
          @user.update(balance: @user.balance - total_cost)
           @user.stocks.find_or_create_by(symbol: @symbol) do |stock|
           stock.quantity += @quantity
            stock.average_price = ((stock.average_price * stock.quantity) + (stock_price * @quantity)) / (stock.quantity + @quantity)
      end
  
        redirect_to stock_path(@symbol), notice: "Successfully bought #{@quantity} shares of #{@symbol}!"
      else
        redirect_to stock_path(@symbol), alert: "Insufficient balance to buy #{@quantity} shares of #{@symbol}."
      end
    end
  