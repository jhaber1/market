class Checkout
  attr_accessor :discounts, :ineligible_discounts, :total, :cart

  def initialize(*discounts)
    @cart = []
    @total = 0
    @discounts = discounts
    @ineligible_discounts = []
  end

  # Adds a new item to the cart and outputs the updated cart.
  #
  # @param [Item] item
  # @return output to STDOUT
  def scan(item)
    self.cart << item.clone
    check_for_discounts if @discounts.any?
    calculate_total
    display_cart
  end

  # Calculates total cast of all scanned items.
  #
  def calculate_total
    self.total = cart.inject(0) do |result, item|
      result += item.price - item.discount_price
      result
    end
  end

  def display_cart

  end

  # Checks for and applies discounts on the cart.
  #
  def check_for_discounts
    # Select all still-eligible discounts and apply their discounts
    discounts.reject { |d| self.ineligible_discounts.include?(d.code) }.each do |discount|

      discount_proc = discount.get_discount_logic
      applied = discount_proc.call(discount, cart)



      if applied && discount.code == 'CHMK'
        self.ineligible_discounts << discount.code if !self.ineligible_discounts.include?(discount.code)
      end

    end

  end

  def empty_cart
    self.cart = []
    self.total = 0
    self.ineligible_discounts = []
  end




  def self.output_table(cart)

  end
end