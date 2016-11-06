class Discount
  #attr_writer :eligible
  attr_reader :code

  def initialize(code)
    @code = code
    #@eligible = true
  end

  def get_discount_logic
    self.class.discounts[self.code]#.call(self, items)
  end

  # def eligible?
  #   @eligible
  # end



  # Hash of procs that contains the code necessary to apply discounts to items.
  def self.discounts
    {
      # Buy-One-Get-One-Free Special on Coffee. (Unlimited)
      'BOGO' => -> (discount, items) do
        conditions_met = false

        # Get all coffees with no applied discounts
        items.select { |i| i.product_code == 'CF1' && i.discount_code.nil? && i.discount_price.zero? }.each do |item|

          # If we already have 1 coffee, then apply discount to the current one
          if conditions_met
            item.discount_code = discount.code
            item.discount_price = item.price

            conditions_met = false
          else
            conditions_met = true
          end
        end

        true
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

        #discount.eligible = false
      end
    }
  end

end