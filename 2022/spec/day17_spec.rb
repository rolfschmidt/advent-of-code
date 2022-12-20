Rock = Struct.new(:x, :y, :shape) do
  attr_accessor :pos
  attr_accessor :diff_height

  def initialize(*)
    super

    if shape == :hline
      @pos = [
        [x + 2, y],
        [x + 3, y],
        [x + 4, y],
        [x + 5, y],
      ]
    elsif shape == :plus
      @pos = [
        [x + 3, y],
        [x + 3, y - 1],
        [x + 3, y - 2],
        [x + 2, y - 1],
        [x + 4, y - 1],
      ]
    elsif shape == :lleft
      @pos = [
        [x + 2, y],
        [x + 3, y],
        [x + 4, y],
        [x + 4, y - 1],
        [x + 4, y - 2],
      ]
    elsif shape == :vline
      @pos = [
        [x + 2, y],
        [x + 2, y - 1],
        [x + 2, y - 2],
        [x + 2, y - 3],
      ]
    elsif shape == :box
      @pos = [
        [x + 2, y],
        [x + 2, y - 1],
        [x + 3, y],
        [x + 3, y - 1],
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

  def diff
    @diff ||= [diff_height, shape]
  end
end

Chamber = Struct.new(:move_data, :part2) do
  attr_accessor :saved
  attr_accessor :highest
  attr_accessor :cheat_highest
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
    @move_index          = 0
    @cheat_highest       = 0
  end

  def miny
    (blocks.last(10).map(&:miny).min || 0) - 4
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

  def highest_block(block)
    block.pos.each do |x, y|
      @highest = [@highest, y].min
    end
  end

  def save_block(block)
    block.pos.each do |x, y|
      @saved[[x,y]] = true
    end
  end

  def cleanup
    return
    clean_when = moves.count * 100
    clean_to   = moves.count * 10
    if blocks.count > clean_when
      @blocks = blocks.last(clean_to)

      @saved = {}
      blocks.each do |block|
        save_block(block)
      end
    end
  end

  def new_shape
    @shape_pos += 1
    if @shape_pos > shapes.count - 1
      @shape_pos = 0
    end

    shape = shapes[shape_pos]
    Rock.new(0, miny, shape)
  end

  def peek_shapes(val)
    current = shape_pos
    result  = []
    val.times do
      current += 1
      if current > shapes.count - 1
        current = 0
      end
      result << shapes[current]
    end
    result
  end

  def move(block, ds)
    new_block = ddup(block)
    block.pos.each_with_index do |pos, i|
      return if pos[1] + ds[1] == maxy
      return if pos[0] + ds[0] == maxx
      return if pos[0] + ds[0] < minx

      new_block.pos[i][0] += ds[0]
      new_block.pos[i][1] += ds[1]
    end

    return if collides_any?(new_block)

    new_block
  end


  def move2(block, ds)
    new_block = ddup(block)
    block.pos.each_with_index do |pos, i|
      return if pos[1] + ds[1] == maxy
      return if pos[0] + ds[0] == maxx
      return if pos[0] + ds[0] < minx

      new_block.pos[i][0] += ds[0]
      new_block.pos[i][1] += ds[1]
    end

    return if collides_any?(new_block)

    new_block
  end

  def collides_any?(b2)
    return b2.pos.any?{|x, y| saved[[x,y]] }
  end

  def peek_index(val)
    current = move_index
    result  = []
    val.times do
      current += 1
      if current == moves.count
        current = 0
      end
      result << current
    end
    result
  end

  def find_range(circle_range)
  #   snapshots = []
  #   (highest + circle_range..-circle_range).each_cons(circle_range).each do |ry|
  #     snapshot = {}

  #     blocks.each do |block|
  #       block.pos.each do |pos|
  #         x, y = pos
  #         throw :done if y < ry.first
  #         throw :done if y > ry.last

  #         snapshot[[x, ry.last - y]] = true
  #       end
  #     end

  #     snapshots << snapshot
  #   end

  #   snapshots.each_with_index do |sfirst, i|
  #     if snapshots.select{|s| s == sfirst }.count >= circle_range
  #       height = sfirst.keys.map{|p| p[1] }.sum
  #       return [height, circle_range, sfirst]
  #     end
  #   end
  #   binding.pry
  #   return
  # rescue => e
  #   binding.pry

    block_shapes   = blocks.map{|b| [b.shape, b.pos.map{|p| p[0] }] }
    blocks_diff    = blocks.map(&:diff)
    blocks_heights = blocks.map(&:diff_height)

    repetition    = 5
    (0..blocks.count - 1 - circle_range * repetition).each do |i|
      diff_shapes  = block_shapes[i..i + (circle_range * repetition) - 1]
      diff_heights = blocks_heights[i..i + (circle_range * repetition) - 1]
      diff_both    = blocks_diff[i..i + (circle_range * repetition) - 1]
      raise "#{diff_shapes.count}/#{block_shapes.count} - #{circle_range * repetition} -- #{i}..#{i + (circle_range * repetition) - 1}" if diff_shapes.count != circle_range * repetition

      citems = diff_both.first(circle_range)
      cfirst = diff_shapes.first(circle_range)
      hfirst = diff_heights.first(circle_range)
      # cnext  = peek_index(circle_range).zip(peek_shapes(circle_range))

      if diff_shapes == cfirst * repetition && diff_heights.sum == hfirst.sum * repetition
        return [circle_range, citems, i]
      end
    end
    puts "done"
  end

  def run
    stop_count = 0
    while true do
      show

      old_block = @blocks.pop || new_shape
      new_block = move(old_block, [0, 1])
      if !new_block
        stop_count += 1

        @blocks << old_block

        old_highest = highest
        highest_block(old_block)
        save_block(old_block)
        cleanup

        old_block.diff_height = (highest - (old_highest || 0)).to_i

        break if stop_count == 2022 && !part2
        # break if stop_count == 6 && !part2
        break if stop_count == 1000000000000 && part2
        # break if stop_count == 2022 && part2

        if stop_count % 1000 == 0
          puts stop_count
        end

        if stop_count >= 300000 && part2 && !@cheated
          @cheated = true
          if stop_count % 1000 == 0
            puts stop_count
          end

          # (30..blocks.count / 2).each do |ri|
          #   height, circle_range, snapshot = find_range(ri)
          #   if circle_range.present?
          #     binding.pry
          #     rest_count = 1000000000000 - stop_count
          #     rounds     = (rest_count / height).to_i

          #     if rounds > 0
          #       stop_count -= 1
          #       stop_count += rounds * height
          #       @cheat_highest += rounds * height
          #       puts "CHEAT #{cheat_highest} on #{ri}"
          #       puts "New round #{stop_count}"
          #       puts "REST #{rest_count}"
          #       puts "circle_range #{circle_range}"
          #       puts "height #{height}"

          #       # blocks.each_with_index do |_, bi|
          #       #   blocks[bi].pos.each_with_index do |bp, bpi|
          #       #     @blocks[bi].pos[bpi][1] += @cheat_highest
          #       #   end
          #       #   highest_block(blocks[bi])
          #       #   save_block(blocks[bi])
          #       # end

          #       # @shape_pos  = shapes.index(circle_items.first[1])
          #       # @move_index = circle_items.first[0]
          #       break
          #     end
          #   end


          (1..5000).each do |ri|
            circle_range, circle_items, circle_index = find_range(ri)
            if circle_items.present?
              binding.pry

              circle_sum = circle_items.map{|c| c[0] }.sum
              rest_count = 1000000000000 - stop_count
              rounds     = (rest_count / circle_items.count).to_i

              if rounds > 0
                stop_count -= 1
                stop_count += rounds * circle_items.count
                @cheat_highest += rounds * circle_sum
                puts "CHEAT #{cheat_highest} on #{ri}"
                puts "New round #{stop_count}"
                puts "REST #{rest_count % circle_items.count}"

                # blocks.each_with_index do |_, bi|
                #   blocks[bi].pos.each_with_index do |bp, bpi|
                #     @blocks[bi].pos[bpi][1] += @cheat_highest
                #   end
                #   highest_block(blocks[bi])
                #   save_block(blocks[bi])
                # end

                # @shape_pos  = shapes.index(circle_items.first[1])
                # @move_index = circle_items.first[0]
                break
              end
            end
          end
        end

        @blocks << new_shape
        show
      else
        @blocks << new_block
      end

      #
      # GAS
      #

      old_block = @blocks.pop
      next_move = moves[move_index]
      # puts "#{next_move.inspect} of index #{move_index}"
      new_block = move(old_block, next_move)
      if !new_block
        @blocks << old_block
      else
        @blocks << new_block
      end

      @move_index += 1
      if move_index == moves.count
        @move_index = 0
      end
    end

    stop_count
  end

  def show
    return
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

    # require 'ruby-prof'
    # RubyProf.start

    chamber = Chamber.new(moves, part2)
    stop_count = chamber.run
    # chamber.show

    puts "STOP: #{stop_count}"

    pp chamber.highest.abs + chamber.cheat_highest.abs
    result = chamber.highest.abs + chamber.cheat_highest.abs

    # result = RubyProf.stop
    # printer = RubyProf::FlatPrinter.new(result)
    # printer.print(STDOUT)

    raise if 1514285714288 != result && moves.count == 40

    result
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day17" do
  # it "does part 1" do
  #   expect(Day17.part1).to eq(3181)
  # end

  it "does part 2" do
    expect(Day17.part2).to eq(1570434782634)
  end # 2199999998746
end