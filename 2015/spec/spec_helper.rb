require 'rails'
require 'active_support/all'
require 'benchmark'

require 'dijkstra_trace'
require 'parallel'
require 'ruby-prof'

require 'pry'
require 'byebug'
require 'range_operators'
require 'rb_heap'
require 'rainbow'
require 'z3' # equations

require '../helper'

RSpec.configure do |config|
  config.default_formatter = "doc"
end

