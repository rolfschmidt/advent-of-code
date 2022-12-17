Rock = Struct.new(:x, :y, :shape, :moving) do
  attr_accessor :pos

  def initialize(*)
    super

    if shape == :hline
      @pos = [
        [x, y],
        [x - 1, y],
        [x + 1, y],
        [x + 2, y],
      ]
    elsif shape == :plus
      @pos = [
        [x, y],
        [x, y - 1],
        [x, y - 2],
        [x - 1, y - 1],
        [x + 1, y - 1],
      ]
    elsif shape == :lleft
      @pos = [
        [x, y],
        [x - 1, y],
        [x + 1, y],
        [x + 1, y - 1],
        [x + 1, y - 2],
      ]
    elsif shape == :vline
      @pos = [
        [x - 1, y],
        [x - 1, y - 1],
        [x - 1, y - 2],
        [x - 1, y - 3],
      ]
    elsif shape == :box
      @pos = [
        [x, y],
        [x, y - 1],
        [x - 1, y],
        [x - 1, y - 1],
      ]
    else
      raise
    end
  end

  def minx
    pos.map {|v| v[0] }.min
  end

  def miny
    pos.map {|v| v[1] }.min
  end

  def maxx
    pos.map {|v| v[0] }.max
  end

  def maxy
    pos.map {|v| v[1] }.max
  end
end

Chamber = Struct.new(:move_data, :part2) do
  attr_accessor :saved
  attr_accessor :highest
  attr_accessor :block_history
  attr_accessor :block_history_count
  attr_accessor :moves
  attr_accessor :move_index
  attr_accessor :shapes
  attr_accessor :blocks
  attr_accessor :shape_pos

  def initialize(*)
    super
    @moves               = self.move_data
    @blocks              = []
    @shapes              = [:hline, :plus, :lleft, :vline, :box]
    @shape_pos           = -1
    @highest             = 1
    @saved               = {}
    @block_history       = []
    @block_history_count = []
    @move_index          = 0
  end

  def miny
    (blocks.map(&:miny).min || 0) - 4
  end

  def maxy
    1
  end

  def minx
    0
  end

  def maxx
    7
  end

  def highest_block(block, stop_count)
    block.pos.each do |x, y|
      @highest = [@highest, y].min
    end
  end

  def save_block(block)
    block.pos.each do |x, y|
      @saved["#{x}_#{y}"] = true
    end
  end

  def new_shape
    @shape_pos += 1
    if @shape_pos > shapes.count - 1
      @shape_pos = 0
    end

    shape = shapes[shape_pos]
    Rock.new(3, miny, shape, true)
  end

  def move(block, ds)
    new_block = ddup(block)
    block.pos.each_with_index do |pos, i|
      return if pos[1] + ds[1] == maxy
      return if pos[0] + ds[0] == maxx
      return if pos[0] + ds[0] < minx

      tmp_block = ddup(new_block)
      tmp_block.pos[i][0] += ds[0]
      tmp_block.pos[i][1] += ds[1]
      return if collides_any?(tmp_block)

      new_block.pos[i][0] += ds[0]
      new_block.pos[i][1] += ds[1]
    end

    new_block
  end

  def collides_any?(b2)
    return b2.pos.any?{|x, y| saved["#{x}_#{y}"] }
  end

  def find_range(move_index, shape)
    block_size = moves.count * 10

    puts "check size #{block_size}"
    block_history.each_cons(block_size).with_index do |r1, r1i|
      block_history.each_cons(block_size).with_index do |r2, r2i|
        next if r1i == r2i
        next if r2.first[0] != move_index
        next if r2.first[1] != shape
        next if r1 != r2

        if r1 == r2
           puts "found range #{r1.join(",")}"
           puts "r2 #{r2.join(",")}"
           return r1
        end
      end
    end

    nil
  end

  def run
    @blocks << new_shape

    stop_count = 0
    while true do
      old_block = @blocks.pop
      new_block = move(old_block, [0, 1])
      if !new_block
        stop_count += 1

        @blocks << old_block

        old_highest = highest
        highest_block(old_block, stop_count)
        save_block(old_block)

        @block_history << [move_index, old_block.shape, highest - (old_highest || 0)]
        @block_history << [move_index, old_block.shape]
        @block_history_count << highest

        break if stop_count == 2022 && !part2

        @blocks << new_shape
      else
        @blocks << new_block
      end

      #
      # GAS
      #

      old_block    = @blocks.pop
      @move_index += 1

      if move_index == moves.count
        @move_index = 0
      end

      if stop_count >= 2022 && part2
        puts stop_count

        range = find_range(move_index, old_block.shape)
        if range
          puts "found range #{range}"
          binding.pry
        end
      end

      next_move = moves[move_index]
      new_block = move(old_block, next_move)
      if !new_block
        @blocks << old_block
        next
      end

      @blocks << new_block
    end

  end

  def show
    (miny..1).to_a.each do |y|
      (-1..7).to_a.each do |x|
        if x == -1 && y == 1
          print "+"
        elsif x == 7 && y == 1
          print "+"
        elsif x == -1
          print "|"
        elsif x == 7
          print "|"
        elsif y == 1
          print "-"
        else
          found = false
          blocks.each do |block|
            next if block.pos.exclude?([x, y])

            print "@"
            found = true

            break
          end

          next if found

          print "."
        end
      end

      print "\n"
    end
  end
end

class Day17 < Helper
  def self.part1(part2 = false)
    moves = []
    file.split("").each do |v|
      if v == '>'
        moves << [1, 0]
      else
        moves << [-1, 0]
      end
    end

    chamber = Chamber.new(moves, part2)
    chamber.run

    return chamber.highest.abs + 1
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day17" do
  it "does part 1" do
    expect(Day17.part1).to eq(3181)
  end

  # it "does part 2" do
  #   expect(Day17.part2).to eq(100)
  # end
end