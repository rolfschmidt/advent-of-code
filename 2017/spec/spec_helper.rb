require 'rails'
require 'active_support/all'

require 'dijkstra_trace'
require 'parallel'

require 'pry'
require 'byebug'

require '../helper'

RSpec.configure do |config|
  config.default_formatter = "doc"
end

