class Item
  attr_reader :product_code, :price
  attr_accessor :discount_code, :discount_price

  def initialize(product_code, price)
    @product_code = product_code
    @price = price
    @discount_code = nil
    @discount_price = 0
  end
end