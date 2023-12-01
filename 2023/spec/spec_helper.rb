require 'rails'
require 'active_support/all'

require 'dijkstra_trace'
require 'parallel'
require 'ruby-prof'

require 'pry'
require 'byebug'

require '../helper'

RSpec.configure do |config|
  config.default_formatter = "doc"
end

