require 'spec_helper'
require 'byebug'
require 'awesome_print'

describe 'Checkout' do
  let!(:bogo) { Discount.new('BOGO') }
  let!(:appl) { Discount.new('APPL') }
  let(:chmk) { Discount.new('CHMK') }

  let!(:co) { Checkout.new(bogo, appl, chmk) }

  let!(:chai) { Item.new('CH1', 3.11) }
  let!(:apples) { Item.new('AP1', 6.00) }
  let!(:coffee) { Item.new('CF1', 11.23) }
  let!(:milk) { Item.new('MK1', 4.75) }

  #after(:each) { co.empty_cart }

  it 'gets the correct total for the given items' do

    # Supplied tests

    # Basket: CH1, AP1, CF1, MK1
    # Total price expected: $20.34
    # co.scan(chai)
    # co.scan(apples)
    # co.scan(coffee)
    # co.scan(milk)
    # expect(co.total).to eql(20.34)
    #
    # co.empty_cart
    #
    # # Basket: MK1, AP1
    # # Total price expected: $10.75
    #
    # co.scan(milk)
    # co.scan(apples)
    # expect(co.total).to eql(10.75)
    #
    # co.empty_cart
    #
    # # Basket: CF1, CF1
    # # Total price expected: $11.23
    # co.scan(coffee)
    # co.scan(coffee)
    # expect(co.total).to eql(11.23)
    #
    # co.empty_cart

    # Basket: AP1, AP1, CH1, AP1
    # Total price expected: $16.61
    debugger
    co.scan(apples)
    co.scan(apples)
    co.scan(chai)
    co.scan(apples)
    expect(co.total).to eql(16.61)



    # Additional use cases
  end
end