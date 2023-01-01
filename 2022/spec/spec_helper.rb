require 'rails'
require 'active_support/all'

require 'dijkstra_trace'
require 'parallel'
require 'ruby-prof'

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

# +3x speed <=> matrix/Vector
Vector = Struct.new(:x, :y) do
  def self.[](x, y)
    self.new(x, y)
  end

  def +(v)
    self.class.new(self.x + v.x, self.y + v.y)
  end

  def -(v)
    self.class.new(self.x - v.x, self.y - v.y)
  end

  def *(v)
    self.class.new(self.x * v.x, self.y * v.y)
  end

  def /(v)
    self.class.new(self.x / v.x, self.y / v.y)
  end

  def magnitude
    Math.sqrt(self.x.abs2 + self.y.abs2)
  end
  alias_method :r, :magnitude
  alias_method :norm, :magnitude

  def to_a
    [x, y]
  end

  def ==(other)
    [x, y] == [other.x, other.y]
  end
  alias_method :==, :eql?

  def hash
    [x, y].hash
  end
end

def prof
  RubyProf.start
  yield
  result = RubyProf.stop
  printer = RubyProf::FlatPrinter.new(result)
  printer.print(STDOUT)
end

def ddup(obj)
  Marshal.load(Marshal.dump(obj))
end

RSpec.configure do |config|
  config.default_formatter = "doc"
end

