#!/usr/bin/env ruby

require 'byebug'
require 'awesome_print'
require File.expand_path('lib/market')

bogo = Discount.new('BOGO')
appl = Discount.new('APPL')
chmk = Discount.new('CHMK')
co = Checkout.new(bogo, appl, chmk)

chai = Item.new('CH1', 3.11)
apples = Item.new('AP1', 6.00)
coffee = Item.new('CF1', 11.23)
milk = Item.new('MK1', 4.75)

# CH1, AP1, AP1, AP1, MK1
co.scan(chai)
co.scan(apples)
co.scan(apples)
co.scan(apples)
co.scan(milk)
