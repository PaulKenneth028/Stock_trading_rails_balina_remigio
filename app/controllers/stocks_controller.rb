# app/controllers/stocks_controller.rb

class StocksController < ApplicationController
    def show
      @symbol = params[:symbol]
      
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
  end
  