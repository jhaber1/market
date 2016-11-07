require 'spec_helper'

describe 'Checkout' do
  let!(:bogo) { Discount.new('BOGO') }
  let!(:appl) { Discount.new('APPL') }
  let(:chmk) { Discount.new('CHMK') }

  let!(:co) { Checkout.new(bogo, appl, chmk) }

  let!(:chai) { Item.new('CH1', 3.11) }
  let!(:apples) { Item.new('AP1', 6.00) }
  let!(:coffee) { Item.new('CF1', 11.23) }
  let!(:milk) { Item.new('MK1', 4.75) }

  # Silences cart output
  before(:each) { allow(co).to receive(:puts).and_return(nil) }
  after(:each) { co.empty_cart }

  context 'Supplied use cases' do
    # Basket: CH1, AP1, CF1, MK1
    # Total price expected: $20.34
    it 'gets the correct total for the given items' do
      co.scan(chai)
      co.scan(apples)
      co.scan(coffee)
      co.scan(milk)
      expect(co.total).to eql(20.34)
    end

    # Basket: MK1, AP1
    # Total price expected: $10.75
    it 'gets the correct total for the given items' do
      co.scan(milk)
      co.scan(apples)
      expect(co.total).to eql(10.75)
    end

    # Basket: CF1, CF1
    # Total price expected: $11.23
    it 'gets the correct total for the given items' do
      co.scan(coffee)
      co.scan(coffee)
      expect(co.total).to eql(11.23)
    end

    # Basket: AP1, AP1, CH1, AP1
    # Total price expected: $16.61
    it 'gets the correct total for the given items' do
      co.scan(apples)
      co.scan(apples)
      co.scan(chai)
      co.scan(apples)
      expect(co.total).to eql(16.61)
    end
  end

  context 'Additional use cases' do
    # 2 coffee discounts
    it 'gets the correct total for the given items' do
      4.times { co.scan(coffee) }
      expect(co.total).to eql(22.46)
    end

    # more than 3 apples
    it 'gets the correct total for the given items' do
      5.times { co.scan(apples) }
      expect(co.total).to eql(22.50)
    end

    # 2 sets of chai/milk to ensure discount gets applied only once
    it 'gets the correct total for the given items' do
      2.times do
        co.scan(chai)
        co.scan(milk)
      end
      expect(co.total).to eql(10.97)
    end

  end
end
