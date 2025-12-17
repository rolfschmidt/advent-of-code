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
require './spec/machine'

RSpec.configure do |config|
  config.default_formatter = "doc"

  config.around(:each) do |example|
    start_time = Time.now
    puts example.run
    end_time = Time.now
    duration = end_time - start_time
    puts "in #{'%.3f' % duration.to_f}s:"
  end

  config.after(:all) do |example|
    if $cache_counter_set.positive? && $cache_counter_get.positive?
      puts
      cache_in = $cache_counter_set.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      cache_out = $cache_counter_get.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1.")
      puts "Cache used in: #{cache_in}, out: #{cache_out}"
      $cache_counter_set = 0
      $cache_counter_get = 0
    end
  end
end
