class StockTransaction < ApplicationRecord
  belongs_to :user
  has_many :stocks

  attr_accessor :latest_price
end
