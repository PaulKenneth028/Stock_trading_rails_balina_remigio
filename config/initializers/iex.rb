# config/initializers/iex.rb

IEX::Api.configure do |config|
    config.publishable_token = 'pk_3dbda283b9094177a492240a433bafa8'
    config.secret_token = 'sk_47ec9c4cad8444ffb0cde92bb3fbbe2a' # Only required for certain endpoints
    config.endpoint = 'https://cloud.iexapis.com/v1' # Defaults to IEX Cloud endpoint
  end
  