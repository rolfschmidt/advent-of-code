class String
  def halve
    [self[0, self.size/2], self[self.size/2..-1]]
  end

  def is_upper?
    self == self.upcase
  end

  def is_lower?
    self == self.downcase
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

  def manhattan(pos)
    (self.x - pos.x).abs + (self.y - pos.y).abs
  end

  alias_method :r, :magnitude
  alias_method :norm, :magnitude

  def to_a
    [x, y]
  end

  def ==(other)
    x == other.x && y == other.y
  end
  alias_method :==, :eql?

  def hash
    [x, y].hash
  end
end

class Node
  attr_accessor :value, :prev, :next

  def initialize(value)
    @value = value
    @prev = self
    @next = self
  end

  def delete
    @prev.next = @next
    @next.prev = @prev
    @value
  end

  def insert(value)
    node = Node.new(value)
    node.prev = self
    node.next = @next
    @next.prev = node
    @next = node
    node
  end
end

def ddup(obj)
  Marshal.load(Marshal.dump(obj))
end
