# app/services/iex_service.rb
require 'rest-client'

class IexService
  def initialize(api_key)
    @api_key = 'pk_3dbda283b9094177a492240a433bafa8'
  end

  def stock_quote(symbol)
    return nil if symbol.blank?

    response = RestClient.get("https://cloud.iexapis.com/v1/stock/#{symbol}/quote?token=#{@api_key}")
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error("IEX API Error: #{e.message}, Response Body: #{e.response.body}")
    nil
  end
end
