class Integer
  def to_range
    (self..self)
  end

  def to_vec
    Vector.new(self, self)
  end

  def to_vec3
    Vector3.new(self, self, self)
  end
end

class BigDecimal
  def to_vec
    Vector.new(self, self)
  end

  def to_vec3
    Vector3.new(self, self, self)
  end
end

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

  def to_map
    result = {}
    self.each_with_index do |y, yi|
      y.each_with_index do |x, xi|
        result[Vector.new(xi, yi)] = x
      end
    end
    result
  end

  def select_vec(value = nil)
    result = []
    self.each_with_index do |y, yi|
      y.each_with_index do |x, xi|
        next if value && x != value

        result << Vector.new(xi, yi)
      end
    end
    result
  end

  def ensure_ranges
    self.map{|v| v.is_a?(Range) ? v : v.to_range }
  end

  def add_range(values)
    self.map do |r|
      r = r.to_range if r.respond_to?(:to_range)
      Array.wrap(values).each do |value|
        value = value.to_range if value.respond_to?(:to_range)
        r += value
      end
      r
    end.flatten.compact.rangify.ensure_ranges
  end

  def sub_range(values)
    self.map do |r|
      r = r.to_range if r.respond_to?(:to_range)
      Array.wrap(values).each do |value|
        value = value.to_range if value.respond_to?(:to_range)
        r -= value
      end
      r
    end.flatten.compact.rangify.ensure_ranges
  end

  def intersect_range(values)
    self.map do |r|
      r = r.to_range if r.respond_to?(:to_range)
      Array.wrap(values).each do |value|
        value = value.to_range if value.respond_to?(:to_range)
        r = r & value
      end
      r
    end.flatten.compact.rangify.ensure_ranges
  end

  def keys
    each_keys.to_a
  end

  def each_keys
    (0..self.count - 1)
  end

  def minx
    0
  end

  def maxx
    self[0].size - 1
  end

  def miny
    0
  end

  def maxy
    self.size - 1
  end

  # Umfang / Edge length
  def poligon_perimeter
    self.each_cons(2).sum {|a, b| a.poligon_distance(b) }
  end

  # https://stackoverflow.com/a/4937281
  # https://en.wikipedia.org/wiki/Shoelace_formula
  def poligon_inner_area
    self.each_cons(2).sum {|a, b| (a.x * b.y) - (b.x * a.y) }.abs / 2
  end

  # https://en.wikipedia.org/wiki/Pick%27s_theorem
  def poligon_area
    (self.poligon_inner_area + (self.poligon_perimeter / 2) + 1)
  end
end

class Hash
  def minx
    @minx ||= {}
    @minx[hash] ||= self.keys.min_by{|v| v[0] }.x
  end

  def maxx
    @maxx ||= {}
    @maxx[hash] ||= self.keys.max_by{|v| v[0] }.x
  end

  def miny
    @miny ||= {}
    @miny[hash] ||= self.keys.min_by{|v| v[1] }.y
  end

  def maxy
    @maxy ||= {}
    @maxy[hash] ||= self.keys.max_by{|v| v[1] }.y
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
    v = v.to_vec if v.respond_to?(:to_vec)
    self.class.new(self.x + v.x, self.y + v.y)
  end

  def -(v)
    v = v.to_vec if v.respond_to?(:to_vec)
    self.class.new(self.x - v.x, self.y - v.y)
  end

  def *(v)
    v = v.to_vec if v.respond_to?(:to_vec)
    self.class.new(self.x * v.x, self.y * v.y)
  end

  def /(v)
    v = v.to_vec if v.respond_to?(:to_vec)
    self.class.new(self.x / v.x, self.y / v.y)
  end

  def poligon_distance(pos)
    Math.sqrt((pos.x - self.x).abs2 + (pos.y - self.y).abs2)
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

Vector3 = Struct.new(:x, :y, :z) do
  def self.[](x, y)
    self.new(x, y)
  end

  def self.random
    self.new(rand(-1.0..1.0), rand(-1.0..1.0), rand(-1.0..1.0))
  end

  def +(v)
    v = v.to_vec3 if v.respond_to?(:to_vec3)
    self.class.new(self.x + v.x, self.y + v.y, self.z + v.z)
  end

  def -(v)
    v = v.to_vec3 if v.respond_to?(:to_vec3)
    self.class.new(self.x - v.x, self.y - v.y, self.z - v.z)
  end

  def *(v)
    v = v.to_vec3 if v.respond_to?(:to_vec3)
    self.class.new(self.x * v.x, self.y * v.y, self.z * v.z)
  end

  def /(v)
    v = v.to_vec3 if v.respond_to?(:to_vec3)
    self.class.new(self.x / v.x, self.y / v.y, self.z / v.z)
  end

  def product(v)
    self.x * v.x + self.y * v.y + self.z * v.z
  end

  def normalize
    l = self.r
    Vector3.new(self.x / l, self.y / l, self.z / l)
  end

  def magnitude
    Math.sqrt(self.x.abs2 + self.y.abs2 + self.z.abs2)
  end

  alias_method :r, :magnitude
  alias_method :norm, :magnitude

  def to_a
    [x, y, z]
  end

  def ==(other)
    x == other.x && y == other.y && z == other.z
  end
  alias_method :==, :eql?

  def hash
    [x, y, z].hash
  end
end

class Box
  attr_accessor :fx, :fy, :fz, :tx, :ty, :tz

  def initialize(fx, fy, fz, tx, ty, tz)
    @fx = fx
    @fy = fy
    @fz = fz
    @tx = tx
    @ty = ty
    @tz = tz
  end

  def overlaps?(other)
    return [self.fz, other.fz].max <= [self.tz, other.tz].min && [self.fx, other.fx].max <= [self.tx, other.tx].min && [self.fy, other.fy].max <= [self.ty, other.ty].min
  end

  def to_a
    [fx, fy, fz, tx, ty, tz]
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

BigDecimal.limit(100)