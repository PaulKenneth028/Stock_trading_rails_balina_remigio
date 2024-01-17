class TraderController < ApplicationController
  before_action :verify_approved

  def index
    if current_user.approved?
      # Fetch stock data for the trader
      symbol = params[:symbol]
      api_key = 'pk_3dbda283b9094177a492240a433bafa8'
      iex_service = IexService.new(api_key)

      # Fetch data for the top 10 stock symbols
      top_stock_symbols = ['AAPL', 'GOOGL', 'MSFT', 'AMZN', 'TSLA', 'FB', 'NVDA', 'PYPL', 'NFLX', 'INTC']
      @top_stocks_data = top_stock_symbols.first(10).map do |top_symbol|
        iex_data = iex_service.stock_quote(top_symbol)
        
        iex_data
      end

      render 'trader/index'
    else
      render 'pending'
    end
  end

  private

  def verify_approved
    redirect_to pending_path unless current_user.approved?
  end
end
