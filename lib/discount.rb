class Discount
  attr_reader :code

  # Initializes a new Discount object.
  #
  # @param [String] code - discount code that is applied to items
  def initialize(code)
    @code = code
  end

  # Fetches the discount proc to be run in checkout.rb.
  #
  def get_discount_logic
    self.class.discounts[self.code]
  end

  private

  # Hash of procs that contains the code necessary to apply discounts to items. Procs take both the Discount object and
  # array of items as arguments. Meant to be run at "checkout" in checkout.rb.
  #
  def self.discounts
    {
      # Buy-One-Get-One-Free Special on Coffee. (Unlimited)
      'BOGO' => -> (discount, items) do
        # Get all coffees with no applied discounts
        coffees = items.select { |i| i.product_code == 'CF1' && i.discount_code.nil? && i.discount_price.zero? }

        # If we have exactly 2 with no discounts, apply the discount
        if coffees.size == 2
          c1, c2 = coffees

          c1.discount_code = discount.code
          c2.discount_code = discount.code

          # Apply the discount price only to the one that will be free
          c2.discount_price = c2.price

          true
        else
          false
        end
      end,

      # If you buy 3 or more bags of Apples, the price drops to $4.50.
      'APPL' => -> (discount, items) do
        apples = items.select { |i| i.product_code == 'AP1' }

        # If we have 3 or more apples, apply the discount to new ones
        if apples.size >= 3
          apples.select { |a| a.discount_code.nil? && a.discount_price.zero? }.each do |apple|
            apple.discount_code = discount.code
            apple.discount_price = apple.price * 0.25
          end

          true
        else
          false
        end
      end,

      # Purchase a box of Chai and get milk free. (Limit 1)
      'CHMK' => -> (discount, items) do
        chai = items.select { |i| i.product_code == 'CH1' }
        milk = items.select { |i| i.product_code == 'MK1' }

        if chai.any? && milk.any?
          m = milk.first
          m.discount_code = discount.code
          m.discount_price = m.price

          true
        else
          false
        end
      end
    }
  end
end
