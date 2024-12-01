class Integer

=begin

  4.to_range

Returns:

  Range(4..4)

=end

  def to_range
    (self..self)
  end

=begin

  4.to_vec

Returns:

  Vector(4, 4)

=end

  def to_vec
    Vector.new(self, self)
  end

=begin

  4.to_vec

Returns:

  Vector(4, 4, 4)

=end

  def to_vec3
    Vector3.new(self, self, self)
  end
end

class BigDecimal
=begin

  4.to_vec

Returns:

  Vector(4, 4)

=end

  def to_vec
    Vector.new(self, self)
  end

=begin

  4.to_vec

Returns:

  Vector(4, 4, 4)

=end

  def to_vec3
    Vector3.new(self, self, self)
  end
end

class String

=begin

  "###\n#.#\n###".to_2d

Returns:

  [
    "#", "#", "#",
    "#", ".", "#",
    "#", "#", "#",
  ]

=end

  def to_2d
    self.split("\n").map(&:chars)
  end

=begin

  "abcd".halve

Returns:

  ['ab', 'cd']

=end

  def halve
    [self[0, self.size/2], self[self.size/2..-1]]
  end

=begin

  "ABCD".is_upper?

Returns:

  true

=end

  def is_upper?
    self == self.upcase
  end

=begin

  "abcd".is_lower?

Returns:

  true

=end

  def is_lower?
    self == self.downcase
  end

=begin

  "5".is_number?

Returns:

  true

=end

  def is_number?
    self.match?(/-?\d+/)
  end

=begin

  "a 5 b -5 c 10".numbers

Returns:

  [5, -5, 10]

=end

  def numbers
    scan(/-?\d+/).map(&:to_i)
  end

=begin

  "aoc is cool".numbers

Returns:

  ['aoc', 'is', 'cool']

=end

  def words
    scan(/\w+/)
  end
end

class Array

=begin

  [
    "#", "#", "#",
    "#", ".", "#",
    "#", "#", "#",
  ].to_2ds

Returns:

 "###
  #.#
  ###"

=end

  def to_2ds
    result = ""
    self.each_with_index do |y, yi|
      y.each_with_index do |x, xi|
        result += x
      end
      result += "\n"
    end
    result
  end

=begin

  [
    "#", "#", "#",
    "#", ".", "#",
    "#", "#", "#",
  ].pos?(x: 1, y: 1)

Returns:

  true

=end

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

=begin

  [
    "#", "#", "#",
    "#", ".", "#",
    "#", "#", "#",
  ].to_map

Returns:

  {
    Vector(0,0) => '#'
    Vector(0,1) => '#'
    Vector(0,2) => '#'
    # ...
  }

=end

  def to_map
    result = {}
    self.each_with_index do |y, yi|
      y.each_with_index do |x, xi|
        result[Vector.new(xi, yi)] = x
      end
    end
    result
  end

=begin

  [
    "#", "#", "#",
    "#", ".", "#",
    "#", "#", "#",
  ].select_vec('.')

Returns:

  [ Vector(1,1) ]

=end

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

=begin

  [5, Range(5), 5].ensure_ranges

Returns:

  [Range(5), Range(5), Range(5)]

=end

  def ensure_ranges
    self.map{|v| v.is_a?(Range) ? v : v.to_range }
  end

=begin

  [5].add_range([6,7,8])

Returns:

  [Range(5..8)]

=end

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

=begin

  [Range(5..8)].sub_range([6,7,8])

Returns:

  [Range(5..5)]

=end

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

=begin

  [Range(5..7), Range(9..11)].intersect_range([6,7,8])

Returns:

  [Range(6..7)]

=end

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

=begin

  [1, 2, 3].keys

Returns:

  [0, 1, 2]

=end

  def keys
    each_keys.to_a
  end

=begin

  [1, 2, 3].each_keys {|i| puts i }

Returns:

  0 1 2

=end

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

=begin

Formula for Edge length (Umfang)

  [Vector(0,1), ...].poligon_perimeter

Returns:

  100

=end

  # Umfang / Edge length
  def poligon_perimeter
    self.each_cons(2).sum {|a, b| a.poligon_distance(b) }
  end

=begin

Formula for Shoelace

  [Vector(0,1), ...].poligon_inner_area

Returns:

  100

=end

  # https://stackoverflow.com/a/4937281
  # https://en.wikipedia.org/wiki/Shoelace_formula
  def poligon_inner_area
    self.each_cons(2).sum {|a, b| (a.x * b.y) - (b.x * a.y) }.abs / 2
  end

=begin

Formula for Picks Theorem

    current     = Vector.new(0, 1)
    edges       = [current.clone]
    directions.each do |d, t|
      current.x += d.x * t
      current.y += d.y * t
      edges << current.clone
    end

    edges.poligon_area.to_i

Returns:

    100 (see 2023/spec/day_18_spec.rb)

=end

  # https://en.wikipedia.org/wiki/Pick%27s_theorem
  def poligon_area
    (self.poligon_inner_area + (self.poligon_perimeter / 2) + 1)
  end
end

class Hash

=begin

  {
    Vector(0,0) => '#',
    Vector(0,1) => '#',
    Vector(0,2) => '#',
  }

Returns:

   "###
    #.#
    ###"

=end

  def to_2ds
    result = ""
    (self.miny..self.maxy).each do |yi|
      (self.miny..self.maxy).each do |xi|
        result += self[Vector.new(xi, yi)]
      end
      result += "\n"
    end
    result
  end

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

class Graph

  # return a graph matrix for the list of edges
  def self.matrix(edges)
    graph = Dijkstra::Trace.new(edges)
    graph.graph_matrix
  end

=begin

https://en.wikipedia.org/wiki/Stoer%E2%80%93Wagner_algorithm
In graph theory, the Stoer–Wagner algorithm is a recursive algorithm
to solve the minimum cut problem in undirected weighted graphs
with non-negative weights.

edges = [
  ['AA', 'BB', 1],
  ['BB', 'CC', 1],
]

cut, best = Graph.minimum_cut(Graph.matrix(edges))

Returns:

[<min cut>, <graph_list>]
[3, [6, 9, 12, 13, 2, 10, 8, 5, 1]]

=end

  def self.minimum_cut(matrix)
    best = [Float::INFINITY, []]
    n = matrix.length
    co = Array.new(n) { |i| [i] }

    (1...n).each do |ph|
      w = matrix[0].dup
      s = t = 0

      (n - ph).times do
        w[t] = -Float::INFINITY
        s, t = t, w.index(w.max)
        (0...n).each { |i| w[i] += matrix[t][i] }
      end

      current_value = [w[t] - matrix[t][t], co[t]]
      best = [best, current_value].min_by { |a, b| [a, b ? b.size : 0] }
      co[s].concat(co[t])
      (0...n).each { |i| matrix[s][i] += matrix[t][i] }
      (0...n).each { |i| matrix[i][s] = matrix[s][i] }
      matrix[0][t] = -Float::INFINITY
    end

    best
  end

=begin

https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
Dijkstra's algorithm is an algorithm for finding
the shortest paths between nodes in a weighted graph, which
may represent, for example, road networks.

edges = [
  ['AA', 'BB', 1],
  ['BB', 'CC', 1],
]

path = shortest_path(edges, 'AA', 'BB')

Returns:

#<Dijkstra::Path:0x00007f9b96d949a8
  @distance=7,
  @ending_point="HH",
  @path=["JJ", "II", "AA", "DD", "EE", "FF", "GG", "HH"],
  @starting_point="JJ">

  see also 2022/spec/day16_spec.rb

=end

  def self.shortest_path(edges, from, to)
    graph = Dijkstra::Trace.new(edges)
    graph.path(from, to)
  end
end

def ddup(obj)
  Marshal.load(Marshal.dump(obj))
end

BigDecimal.limit(100)