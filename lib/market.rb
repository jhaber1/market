%w(checkout discount item).each { |f| require File.expand_path("lib/#{f}") }
