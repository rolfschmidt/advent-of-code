require 'net/http'
require 'cgi'

class TrueClass
  def to_i
    1
  end
end

class FalseClass
  def to_i
    0
  end
end

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
  def to_vec
    Vector.new(*self.split('_').map(&:to_i))
  end

  def to_vec3
    Vector.new(*self.split('_').map(&:to_i))
  end

=begin

  Modified count function. If one char it counts the char, if string it counts the string.

  "aaa".count('a')
  "aaa".count('aaa')

Returns:

  3
  1

=end

  alias_method :count_original, :count
  def count(value)
    return self.chars.each_cons(value.size).count{|row| row.join == value } if value.size > 1
    return count_original(value)
  end

=begin

  "###\n#.#\n###".lines

Returns:

  [
    "###",
    "#.#",
    "###",
  ]

=end

  alias_method :lines_original, :lines
  def lines(*args, **kwargs, &block)
    return split("\n") if args.first.nil?
    lines_original
  end

=begin

  "###\n\n#.#\n\n###".blocks

Returns:

  [
    "###",
    "#.#",
    "###",
  ]

=end

  def blocks
    split("\n\n")
  end

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

  "###\n#.#\n###".to_2d

Returns:

  {
    Vector(1,1) => '#',
    Vector(1,1) => '#',
  }

=end

  def to_map
    to_2d.to_map
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

=begin

  'abc123abc123'.sub(/.*\Kabc/, 'ABC')

Returns:

  "abc123ABC123"

=end

  def rsub(pattern, replace)
    pattern = Regexp.quote(pattern) if pattern.is_a?(String)
    sub(/.*\K#{pattern}/, replace)
  end
end

class Array

=begin

  Support for quick array to hash method

  [1,2,3].to_h(true)

Returns:

  {
    1: true,
    2: true,
    3: true,
  }

=end

  alias_method :original_to_h, :to_h
  def to_h(*args, **kwargs, &block)
    return self.to_h { [_1, args.first] } if !args.first.nil?

    original_to_h(*args, **kwargs, &block)
  end

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
  ].pos(x: x, y: y)

Returns:

  true

=end

def pos(x, y)
  return if !pos?(x: x, y: y)

  self[y][x]
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

  def to_vec
    Vector.new(self[0], self[1])
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

  def dirs
    path   = self.first.is_a?(String) ? self.map(&:to_vec) : self
    result = []
    (0..path.size - 2).each do |ai|
      va = path[ai]
      vb = path[ai + 1]

      result << vb - va
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

    current     = DIR_DOWN
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

  Hash.init_grid(2)

Returns:

  {
    Vector(0,0) => '.',
    Vector(0,1) => '.',
    Vector(0,2) => '.',
  }

=end

  def self.init_map(to_x, to_y = to_x, char = '.')
    map = {}
    (0..to_y).each do |yi|
      (0..to_x).each do |xi|
        map[[xi, yi].to_vec] = char
      end
    end
    map
  end

=begin

  map.start

Returns:

  Vector(0,0)

=end

  def start
    Vector.new(0, 0)
  end

=begin

  map.stop

Returns:

  Vector(5,5)

=end

  def stop
    Vector.new(maxx, maxy)
  end

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

  def to_2ds(highlight: [], xrange: nil, yrange: nil, fill_nil: false, same_color: false)
    highlight = highlight.clone.map(&:to_vec) if highlight.present? && highlight.first.is_a?(String)

    xrange = (self.minx..self.maxx) if xrange.nil?
    yrange = (self.miny..self.maxy) if yrange.nil?

    result = ""
    yrange.each do |yi|
      xrange.each do |xi|
        pos = Vector.new(xi, yi)
        if fill_nil && self[pos].nil?
          self[pos] = '.'
        end

        if same_color && highlight.include?(pos)
          result += Rainbow(self[pos].to_s).orange
        elsif highlight.first == pos
          result += Rainbow(self[pos].to_s).orange
        elsif highlight.last == pos
          result += Rainbow(self[pos].to_s).red
        elsif highlight.include?(pos)
          result += Rainbow(self[pos].to_s).green
        else
          result += self[pos].to_s
        end
      end
      result += "\n"
    end
    result
  end

=begin

  This function will iterate the 2d grid with x, y

  Full map:

  file.to_map.each_2d do |x, y|
    pp [x, y]
  end

  Fixed area:

  file.to_map.each_2d(11, 7) do |x, y|
    pp [x, y]
  end

=end

  def each_2d(mx = maxx + 1, my = maxy + 1)
    (0..(my - 1)).each do |cy|
      (0..(mx - 1)).each do |cx|
        yield(cx, cy, Vector.new(cx,cy))
      end
    end
  end

=begin

  This function uses a list of area positions and finds the edge positions.

  area = map.flood(Vector.new(0,0))

  edges = map.area_edges(area)

Returns:

  Set.new[Vector.new(1,0)]

=end

  def area_edges(list, directions: DIRS_PLUS)
    result = Set.new
    list.each do |check|
      directions.each do |dir|
        pos = check + dir
        next if list.include?(pos)

        result << [pos, Vector.new(dir.x, dir.y)]
      end
    end

    return result
  end

=begin

  This function uses a list of area edges and reduces it so that there is only one edge per side of the poligion.

  area = map.flood(Vector.new(0,0))
  edges = map.area_edges(area)

  sides = map.area_sides(area)

Returns:

  Set.new[Vector.new(1,0)]

=end

  def area_sides(edges)
    edges_uniq   = Set.new
    edges_search = edges.dup.to_a

    opposite_dirs = {
      DIR_UP => [DIR_LEFT, DIR_RIGHT],
      DIR_DOWN => [DIR_LEFT, DIR_RIGHT],
      DIR_RIGHT => [DIR_UP, DIR_DOWN],
      DIR_LEFT => [DIR_UP, DIR_DOWN],
    }

    while edges_search.present? do
      rowa = edges_search.shift
      posa, dira = rowa

      opposite_dirs[dira].each do |search_dir|
        (1..1000000000000).each do |step|
          rowl = [posa + (search_dir * step), dira]

          if edges_search.include?(rowl)
            edges_search = edges_search.select{ _1 != rowl }
          else
            break
          end
        end
      end

      edges_uniq << rowa
    end
    edges_uniq
  end

=begin

  This function floods a map by their value

  areas = map.flood_areas

Returns:

  [
    Set.new[Vector.new(1,0)],
    Set.new[Vector.new(2,0)],
    Set.new[Vector.new(3,0)],
  ]

=end

  def flood_areas
    areas = []
    seen  = Set.new
    self.each do |pos, value|
      next if seen.include?(pos)

      result = self.flood_pos(pos)

      areas |= [result]
      seen += result
    end

    areas
  end

=begin

  This function floods a specific position and everything with the same value.

  map.flood_pos(Vector.new(0,0))

Returns:

  Set.new[Vector.new(1,0)]

=end

  def flood_pos(start, values: nil, directions: DIRS_PLUS, wrap: false, result: Set.new)
    values = Array.wrap(self[start]).to_set if values.nil?

    return Set.new if result.include?(start)
    result << start

    self.steps(start, directions, wrap: wrap).each do |pos|
      next if values.exclude?(self[pos])

      result += self.flood_pos(pos, values: values, directions: directions, wrap: wrap, result: result)
    end

    return result
  end

  def manhattan_paths(start, stop, block_char: '#')
    result   = []
    path     = []
    cur_pos  = start.clone
    (cur_pos.x..stop.x).each do |xi|
      check_pos = Vector.new(xi, cur_pos.y)
      break if self[check_pos].blank? || self[check_pos] == block_char
      path |= [check_pos]
      cur_pos.x = xi
    end
    (cur_pos.y..stop.y).each do |yi|
      check_pos = Vector.new(cur_pos.x, yi)
      break if self[check_pos].blank? || self[check_pos] == block_char
      path |= [check_pos]
      cur_pos.y = yi
    end

    if cur_pos == stop
      result |= [path]
    end

    path     = []
    cur_pos  = start.clone
    (cur_pos.y..stop.y).each do |yi|
      check_pos = Vector.new(cur_pos.x, yi)
      break if self[check_pos].blank? || self[check_pos] == block_char
      path |= [check_pos]
      cur_pos.y = yi
    end
    (cur_pos.x..stop.x).each do |xi|
      check_pos = Vector.new(xi, cur_pos.y)
      break if self[check_pos].blank? || self[check_pos] == block_char
      path |= [check_pos]
      cur_pos.x = xi
    end

    if cur_pos == stop
      result |= [path]
    end

    result
  end

=begin

  This function provides a short path functionality.
  If the moves are related to a cost factor this can be used.
  If no cost is involved, it will sort by distance.

  stop_on = -> (map:, pos:, path:, seen:, data:, cost_min:) do
    print "."
    return [ path.size, path, seen, data[:cost] ]
  end

  skip_on = -> (map:, pos:, dir:, path:, seen:, data:) do
    next true if map[pos] == '#'

    if data[:last_dir] == dir
      data[:cost] += 1
    else
      data[:cost] += 1001
    end

    data[:last_dir] = dir

    false
  end

  shortest, shortest_path, shortest_seen, cost_min = map.shortest_path(start, stop, stop_on: stop_on, skip_on: skip_on, data: { last_dir: DIR_RIGHT, cost: 0 })

Returns:

  [
    13,
    [...],
    Set[...],
    5,
  ]

=end

  def shortest_path(start, stop, directions: DIRS_PLUS, skip_on: nil, stop_on: nil, data: {})
    shortest      = nil
    shortest_path = nil
    shortest_seen = nil
    cost_min      = nil
    cost_seen     = {}
    pos_dir_seen  = {}

    queue = Heap.new do |a, b|
      if a[3][:cost]
        a[3][:cost] < b[3][:cost]
      elsif shortest.nil?
        a[0].manhattan(stop) < b[0].manhattan(stop)
      else
        a[1].size < b[1].size
      end
    end

    start_seen = Set.new
    start_seen << start.to_s

    queue << [start, [start.to_s], start_seen, data]

    while queue.present? do
      queue_pos, path, seen, data = queue.pop

      if stop_on.present?
        if queue_pos == stop && (cost_min.nil? || cost_min >= data[:cost])
          result = stop_on.call(map: self, pos: queue_pos, path: path, seen: seen, data: data, cost_min: cost_min)
          if result.present?
            shortest, shortest_path, shortest_seen, cost_min = result
            next
          end
        end
      else
        if queue_pos == stop && (shortest.nil? || path.size < shortest)
          shortest      = path.size
          shortest_path = path
          shortest_seen = seen
          next
        end
      end

      steps(queue_pos, directions, with_dir: true).each do |pos, dir|
        next if seen.include?(pos.to_s)

        pos_path = path.clone
        pos_seen = seen.clone
        pos_data = data.deep_dup

        pos_path << pos.to_s
        pos_seen << pos.to_s

        next if skip_on && skip_on.call(map: self, pos: pos, dir: dir, path: pos_path, seen: pos_seen, data: pos_data).present?

        if pos_data.key?(:cost)
          next if cost_min && cost_min < pos_data[:cost]

          cs_key = "#{pos}_#{dir}"
          next if cost_seen[cs_key] && cost_seen[cs_key] < pos_data[:cost]
          cost_seen[cs_key] = pos_data[:cost]
        else
          pos_dir_key = "#{pos}_#{dir}"
          next if pos_dir_seen[pos_dir_key] && pos_dir_seen[pos_dir_key] <= pos_path.size
          pos_dir_seen[pos_dir_key] = pos_path.size
        end

        queue << [pos, pos_path, pos_seen, pos_data]
      end
    end

    return if shortest.blank?
    return [shortest, shortest_path, shortest_seen, cost_min]
  end

=begin

  This function provides the functionality to search a map step-wise until a condition is met.
  Define the stop condition with stop_on and the skip condition which is checked on
  every step with skip_on.

  stop_on = -> (map, start, path) do
    map[start] == 9
  end

  skip_on = -> (map, from, pos, path) do
    map[pos] != map[from] + 1
  end

  result = map.find_paths(start, stop_on: stop_on, skip_on: skip_on)

Returns:

  {
    # amount of total paths to the stop_on
    total: 123,
    # amount of unqiue destinations for the stop_on
    total_destinations: 30,
    # all matchings paths to the destination
    paths: [
      [Vector.new(0,0), Vector.new(0,1)],
      [Vector.new(0,2), Vector.new(0,1)],
    ],
  }

=end

  def find_paths(...)
    result = find_paths_deep(...)

    {
      total: result.count,
      total_destinations: result.map(&:last).uniq.count,
      paths: result,
    }
  end

  def find_paths_deep(start, path: [], directions: DIRS_PLUS, wrap: false, stop_on:, skip_on: nil, data: {})
    result = []

    path << start.to_s if path.blank?

    if stop_on.call(map: self, start: start, path: path, data: data).present?
      result << path
      return result
    end

    self.steps(start, directions, wrap: wrap, with_dir: true).each do |pos, dir|
      pos_path = path.clone
      pos_data = data.deep_dup
      next if pos_path.include?(pos.to_s)
      pos_path << pos.to_s

      next if skip_on && skip_on.call(map: self, from: start, pos: pos, dir: dir, path: pos_path, data: pos_data).present?

      result += self.find_paths_deep(pos, path: pos_path, stop_on: stop_on, skip_on: skip_on, data: pos_data)
    end

    result
  end

=begin

  input = "M.S\n.A.\nM.S"

  input.to_map.select_pattern('MAS')

  input.to_map.select_pattern([
    /^[MS].[MS]$/,
    /^.A.$/,
    /^[MS].[MS]$/,
  ], directions: DIR_RIGHT, maxlength: 3)

  input.to_map.select_pattern('MAS', directions: DIRS_DIAG)

Returns:

  [
    {
      :match     => ["MAS"],
      :direction => #<struct Vector x=1, y=1>,
      :from      => #<struct Vector x=0, y=0>,
      :to        => #<struct Vector x=2, y=2>,
      :list      => [#<struct Vector x=0,  y=0>, #<struct Vector x=1, y=1>, #<struct Vector x=2, y=2>]
    },
    {
      :match     => ["MAS"],
      :direction => #<struct Vector x=1, y=-1>,
      :from      => #<struct Vector x=0, y=2>,
      :to        => #<struct Vector x=2, y=0>,
      :list      => [#<struct Vector x=0, y=2>, #<struct Vector x=1, y=1>, #<struct Vector x=2, y=0>]
    }
  ]

=end

  def select_pattern(pattern, maxlength: nil, directions: DIRS_ALL, wrap: false, xrange: (minx..maxx), yrange: (miny..maxy))
    result = []
    yrange.each do |yi|
      xrange.each do |xi|
        result += select_pattern_pos(Vector.new(xi, yi), pattern, maxlength: maxlength, directions: directions, wrap: wrap)
      end
    end

    result
  end

  def select_pattern_pos(start_pos, pattern_list, maxlength: nil, directions: DIRS_ALL, wrap: false)
    if pattern_list.is_a?(String)
      maxlength    = pattern_list.size if maxlength.nil?
      pattern_list = %r{^#{Regexp.escape(pattern_list)}$}
    end
    maxlength = 10 if maxlength.nil?

    directions   = Array.wrap(directions) if !directions.is_a?(Array)
    pattern_list = Array.wrap(pattern_list) if !pattern_list.is_a?(Array)
    if pattern_list.is_a?(String)
      pattern_list.map! do |pattern|
        maxlength  = pattern.size
        %r{^#{Regexp.escape(pattern)}$}
      end
    end

    result = []
    directions.each do |direction|
      search   = ['']
      pos_list = []
      pattern_list.each_with_index do |pattern, pi|
        pos = Vector.new(start_pos.x + (pi * DIRS_NEXT_LINE[direction].x), start_pos.y + (pi * DIRS_NEXT_LINE[direction].y))
        (0..maxlength - 1).each do |step|
          if !wrap
            pos += direction if step.positive?
            raise 'next_direction' if self[pos].nil?
          else
            pos = Vector.new((start_pos.x + (step * direction.x)) % (maxx + 1), (start_pos.y + (step * direction.y)) % (maxy + 1))
          end

          search[-1] += self[pos]
          pos_list << pos
          next if search[-1] !~ pattern

          if pi < pattern_list.size - 1
            search << ''
            break
          end

          result.push({
            match: search,
            direction: direction,
            from: start_pos,
            to: pos,
            list: pos_list,
          })
          break
        end
      end
    rescue => e
      next if e.message == 'next_direction'
      raise e
    end

    result
  end

=begin

  This function will moves blocks in a certain direction.
  **move_pattern** defines the pattern which is moveable.

  pos = map.select_value('@').keys.first
  new_map = map.push_dir(pos, right, 'O')

=end

  def push_dir(pos, dir, move_pattern, free_char: '.', block_char: '#')
    if self[pos + dir] == free_char
      self[pos], self[pos + dir] = self[pos + dir], self[pos]
      return self
    end

    return if self[pos + dir] == block_char

    xrange = nil
    yrange = nil
    if dir == DIR_DOWN
      xrange = (0..maxx)
      yrange = ((pos.y + dir.y)..maxy)
    elsif dir == DIR_UP
      xrange = (0..maxx)
      yrange = (0..(pos.y + dir.y))
    elsif dir == DIR_RIGHT
      xrange = ((pos.x + dir.x)..maxx)
      yrange = ((pos.y + dir.y)..maxy)
    elsif dir == DIR_LEFT
      xrange = (0..(pos.x + dir.x))
      yrange = (0..(pos.y + dir.y))
    end

    moveable = select_pattern(move_pattern, directions: DIR_RIGHT, xrange: xrange, yrange: yrange).map do |row|
      row[:list].to_set
    end
    moveable_flatten = moveable.present? ? moveable.inject(:+) : Set.new

    return if moveable_flatten.exclude?(pos + dir)

    connected = Set.new
    queue     = [pos]
    seen      = Set.new
    while queue.present?
      check_pos = queue.shift
      connected << check_pos

      next if seen.include?(check_pos)
      seen << check_pos

      steps(check_pos, dir).each do |step_pos|
        next if moveable_flatten.exclude?(step_pos)

        queue << step_pos
        moveable.each do |matching|
          next if matching.exclude?(step_pos)

          matching.each do |also_pos|
            next if also_pos == step_pos
            queue << also_pos
          end
        end
      end
    end

    return if connected.select { connected.exclude?(_1 + dir) }.any? { self[_1 + dir] != free_char }

    new_map = self.clone

    connected = if [DIR_UP, DIR_DOWN].include?(dir)
                  connected.sort_by { _1.y }
                else
                  connected.sort_by { _1.x }
                end

    connected.reverse! if [DIR_DOWN, DIR_RIGHT].include?(dir)

    connected.each do |check_pos|
      new_map[check_pos + dir] = self[check_pos]
      new_map[check_pos] = '.'
    end

    new_map
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

=begin

  map.step(Vector.new(0,0), DIR_RIGHT)

Returns:

  Vector.new(0,1)

=end

  def step(pos, dir, wrap: false)
    if wrap
      Vector.new((pos.x + dir.x) % maxx, (pos.y + dir.y) % maxy)
    else
      pos + dir
    end
  end

=begin

  {
    Vector(0,0) => '#',
    Vector(0,1) => '.',
  }.steps(Vector.new(0,0), DIR_RIGHT)

Returns:

  [ Vector.new(0,1) ]

=end

  def steps(pos, directions = DIRS_PLUS, wrap: false, with_dir: false)
    Array.wrap(directions).each_with_object([]) do |dir, result|
      check = if wrap
                Vector.new((pos.x + dir.x) % maxx, (pos.y + dir.y) % maxy)
              else
                pos + dir
              end

      next if self[check].nil?

      if with_dir
        result << [check, dir]
      else
        result << check
      end
    end
  end

=begin

  {
    Vector(0,0) => '#',
    Vector(0,1) => '.',
    Vector(0,2) => '#',
  }.reverse

Returns:

  {
    '#' => [Vector(0,0), Vector(0,2)],
    '.' => [Vector(0,1)],
  }

=end

  def reverse
    result = {}
    self.each do |key, value|
      result[value] ||= []
      result[value] |= [key]
    end
    result
  end


=begin

  {
    Vector(0,0) => '1',
    Vector(0,1) => '2',
    Vector(0,2) => '3',
  }.map_values(&:to_i)

Returns:

  {
    Vector(0,0) => 1,
    Vector(0,1) => 2,
    Vector(0,2) => 3,
  }

=end

  def map_values
    self.to_h { |key, value| [key, yield(value)] }
  end

=begin

  {
    Vector(0,0) => '#',
    Vector(0,1) => '.',
    Vector(0,2) => '#',
  }.select_value('.')

Returns:

  {
    Vector(0,1) => '.',
  }

=end

  def select_value(search = nil)
    self.select { |key, value| !search.nil? ? Array.wrap(value).include?(search) : yield(value) }
  end

=begin

  {
    Vector(0,0) => '#',
    Vector(0,1) => '.',
    Vector(0,2) => '#',
  }.reject_value('.')

Returns:

  {
    Vector(0,0) => '#',
    Vector(0,2) => '#',
  }

=end

  def reject_value(search = nil)
    self.reject { |key, value| !search.nil? ? Array.wrap(value).include?(search) : yield(value) }
  end
end

class Range
  def each
    if self.first < self.last
      self.to_s=~(/\.\.\./)  ?  last = self.last-1 : last = self.last
      self.first.upto(last)  { |i| yield i}
    else
      self.to_s=~(/\.\.\./)  ?  last = self.last+1 : last = self.last
      self.first.downto(last) { |i|  yield i }
    end
  end

  def intersection(other)
    return nil if (self.max < other.begin or other.max < self.begin)
    [self.begin, other.begin].max..[self.max, other.max].min
  end

  alias_method :&, :intersection
end

class Helper
  def self.get_day(url_ext: '')
    raise 'No session token set: export AOC_SESSION="..."' if ENV['AOC_SESSION'].blank?

    uri_data          = Object.const_source_location(self.to_s).first.numbers
    uri               = URI("https://adventofcode.com/#{uri_data[0].to_i}/day/#{uri_data[1].to_i}#{url_ext}")
    http              = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl      = (uri.scheme == "https")
    request           = Net::HTTP::Get.new(uri.to_s)
    request['Cookie'] = "session=#{ENV['AOC_SESSION']}"
    result            = http.request(request)

    raise "Invalid request: #{result.code} #{result.body}" if !result.code.start_with?('2')

    return result.body.strip
  end

  @@test = false

  def self.file
    path = "spec/#{self.to_s.downcase}.txt"
    if !File.exist?(path)
      File.write(path, get_day(url_ext: '/input'))
    end

    @@test = false

    File.read(path)
  end

  def self.file_test
    path = "spec/#{self.to_s.downcase}_test.txt"
    if !File.exist?(path)
      body = get_day
      raise 'Example not found' if body !~ /<pre><code>(.*?)<\/code><\/pre>/mi

      File.write(path, $1.strip)
    end

    @@test = true

    File.read("spec/#{self.to_s.downcase}_test.txt")
  end

  def self.test?
    @@test
  end

  def self.all_chars
    ("a".."z").to_a + ("A".."Z").to_a
  end

  def self.top
    @top ||= DIR_UP
  end

  def self.right
    @right ||= DIR_RIGHT
  end

  def self.bottom
    @bottom ||= DIR_DOWN
  end

  def self.left
    @left ||= DIR_LEFT
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

result = Graph.shortest_path(edges, 'AA', 'BB')

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

$cache = {}
$cache_counter_set = 0
$cache_counter_get = 0
def cache(*args)
  key = caller(1, 1).first + args.map(&:to_s).to_s
  if $cache.key?(key)
    $cache_counter_get += 1
    return $cache[key]
  end

  $cache_counter_set += 1
  $cache[key] ||= yield
end

def reset_cache
  $cache = {}
end

BigDecimal.limit(100)

DIR_UP         = Vector.new(0, -1)
DIR_RIGHT      = Vector.new(1, 0)
DIR_DOWN       = Vector.new(0, 1)
DIR_LEFT       = Vector.new(-1, 0)
DIR_RIGHT_DOWN = Vector.new(1, 1)
DIR_LEFT_UP    = Vector.new(-1, -1)
DIR_LEFT_DOWN  = Vector.new(-1, 1)
DIR_RIGHT_UP   = Vector.new(1, -1)

DIRS_NEXT_LINE = {
  DIR_RIGHT      => DIR_DOWN,
  DIR_LEFT       => DIR_UP,
  DIR_DOWN       => DIR_RIGHT,
  DIR_UP         => DIR_LEFT,
  DIR_RIGHT_DOWN => DIR_LEFT_UP,
  DIR_LEFT_UP    => DIR_RIGHT_DOWN,
  DIR_LEFT_DOWN  => DIR_RIGHT_UP,
  DIR_RIGHT_UP   => DIR_LEFT_DOWN,
}

DIRS_OPPOSITE = {
  DIR_RIGHT => DIR_LEFT,
  DIR_LEFT  => DIR_RIGHT,
  DIR_UP    => DIR_DOWN,
  DIR_DOWN  => DIR_UP,
  DIR_RIGHT_DOWN => DIR_LEFT_UP,
  DIR_LEFT_UP    => DIR_RIGHT_DOWN,
  DIR_LEFT_DOWN  => DIR_RIGHT_UP,
  DIR_RIGHT_UP   => DIR_LEFT_DOWN,
}

DIRS_STRING = {
  '^' => DIR_UP,
  '>' => DIR_RIGHT,
  'v' => DIR_DOWN,
  '<' => DIR_LEFT,
}

DIRS_STRING_OPPOSITE = {
  DIR_UP => '^',
  DIR_RIGHT => '>',
  DIR_DOWN => 'v',
  DIR_LEFT => '<',
}

DIRS_PLUS = [
  DIR_UP,
  DIR_RIGHT,
  DIR_DOWN,
  DIR_LEFT,
]

DIRS_DIAG = [
  DIR_RIGHT_DOWN,
  DIR_LEFT_UP,
  DIR_LEFT_DOWN,
  DIR_RIGHT_UP,
]

DIRS_ALL = DIRS_PLUS + DIRS_DIAG


