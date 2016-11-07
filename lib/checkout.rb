class Checkout
  attr_accessor :discounts, :ineligible_discounts, :total, :cart

  # Fixed column width for the table output
  COL_WIDTH = 10

  # Creates a new Discount object.
  #
  # @param [Discount] discounts - Pass in Discount objects to have them be eligible for use
  def initialize(*discounts)
    @cart = []
    @total = 0
    @discounts = discounts
    @ineligible_discounts = []
  end

  # Adds a new item to the cart and outputs the updated cart.
  #
  # @param [Item] item
  # @return prints cart to stdout
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
    end.round(2)
  end

  # Displays the current state of the cart in a formatted table printed to stdout.
  # All cells are put into an array and then naively printed 3 at a time.
  #
  def display_cart
    data = self.class.table_header

    self.cart.each do |item|
      # Item price row
      data = data + ["#{item.product_code}".ljust(COL_WIDTH), self.class.blank_col,
                     "#{self.class.zero_pad(item.price)}".rjust(COL_WIDTH)]

      # Discount row if present
      if !item.discount_code.nil? && !item.discount_price.zero?
        data = data + [self.class.blank_col, item.discount_code.center(COL_WIDTH),
                       "-#{self.class.zero_pad(item.discount_price)}".rjust(COL_WIDTH)]
      end
    end

    # Separator + total row
    data = data + self.class.separator + [self.class.blank_col * 2,
                                          "#{self.class.zero_pad(self.total)}".rjust(COL_WIDTH)]

    data.each_slice(3) { |row| puts row.join }
    puts "\n"
  end

  # Checks for and applies discounts to the cart.
  #
  def check_for_discounts
    # Select all still-eligible discounts
    discounts.reject { |d| self.ineligible_discounts.include?(d.code) }.each do |discount|
      # Fetch its proc and run it against the cart
      discount_proc = discount.get_discount_logic

      # Note: despite all discounts returning a boolean, it's only used for the CHMK discount
      applied = discount_proc.call(discount, cart)

      # If we've used the one-time-use CHMK discount, stash it here so we know not to apply it again
      # It's a little hack-y to do it here, but I opted to do this over adding another attribute to Discount (which
      # would have specified how often it could be used)
      if applied && discount.code == 'CHMK'
        self.ineligible_discounts << discount.code if !self.ineligible_discounts.include?(discount.code)
      end
    end
  end

  # Resets Checkout object to its original state.
  #
  def empty_cart
    self.cart = []
    self.total = 0
    self.ineligible_discounts = []
  end

  private

  # Helper methods for table formatting
  class << self
    def table_header
      [
        'Item'.freeze.ljust(COL_WIDTH), blank_col, 'Price'.freeze.rjust(COL_WIDTH),
        '----'.freeze.ljust(COL_WIDTH), blank_col, '-----'.freeze.rjust(COL_WIDTH)
      ]
    end

    def blank_col
      ''.freeze.center(COL_WIDTH)
    end

    def separator
      %w(---------- ---------- ----------)
    end

    # Pads string to 2 decimal points.
    #
    # @param [String] s
    # @return [String]
    def zero_pad(s)
      "%.2f" % s
    end
  end
end
