require 'rails'
require 'active_support/all'

require 'matrix'
require 'dijkstra_trace'

require 'pry'
require 'byebug'

class String
  def halve
    [self[0, self.size/2], self[self.size/2..-1]]
  end
end

class Helper
  def self.file
    File.read("spec/#{self.to_s.downcase}.txt")
  end

  def self.file_test
    File.read("spec/#{self.to_s.downcase}_test.txt")
  end

  def self.all_chars
    ("a".."z").to_a + ("A".."Z").to_a
  end
end

class Struct
  def to_s
    return "#{x}_#{y}" if self.try(:x).present?
    super
  end
end


def ddup(obj)
  Marshal.load(Marshal.dump(obj))
end

RSpec.configure do |config|
  config.default_formatter = "doc"
end

