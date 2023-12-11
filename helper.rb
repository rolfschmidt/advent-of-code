class String
  def to_2d
    self.split("\n").map(&:chars)
  end

  def halve
    [self[0, self.size/2], self[self.size/2..-1]]
  end

  def is_upper?
    self == self.upcase
  end

  def is_lower?
    self == self.downcase
  end

  def is_number?
    self.match?(/-?\d+/)
  end

  def numbers
    scan(/-?\d+/).map(&:to_i)
  end

  def words
    scan(/\w+/)
  end
end

class Array
  def pos?(x: nil, y: nil)
    result = true
    if x && (x < 0 || x > self[0].length - 1)
      result = false
    end
    if y && (y < 0 || y > self.length - 1)
      result = false
    end
    result
  end

  def to_set
    self.each_with_object({}) do |key, result|
      result[key] = true
    end
  end

  def to_map
    result = {}
    self.each_with_index do |y, yi|
      y.each_with_index do |x, xi|
        result[Vector.new(xi, yi)] = x
      end
    end
    result
  end

  def select_vec(value)
    result = []
    self.each_with_index do |y, yi|
      y.each_with_index do |x, xi|
        next if x != value

        result << Vector.new(xi, yi)
      end
    end
    result
  end

  def keys
    each_keys.to_a
  end

  def each_keys
    (0..self.count - 1)
  end
end

class Range
  def intersection(other)
    return nil if (self.max < other.begin or other.max < self.begin)
    [self.begin, other.begin].max..[self.max, other.max].min
  end

  alias_method :&, :intersection
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

  def self.top
    @top ||= Vector.new(0, -1)
  end

  def self.right
    @right ||= Vector.new(1, 0)
  end

  def self.bottom
    @bottom ||= Vector.new(0, 1)
  end

  def self.left
    @left ||= Vector.new(-1, 0)
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
