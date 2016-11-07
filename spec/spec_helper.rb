::ENV['RACK_ENV'] ||= 'test'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
%w(market byebug awesome_print).each { |f| require f }
