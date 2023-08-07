class Day10 < Helper
  def self.dirs
    @dirs ||= [
      Vector.new(1, 0),
      Vector.new(-1, 0),
      Vector.new(0, 1),
      Vector.new(0, -1),
      Vector.new(1, 1),
      Vector.new(-1, -1),
      Vector.new(-1, 1),
      Vector.new(1, -1),
    ]
  end

  def self.calc_coords
    @coords ||= begin
      coords = []
      file.split("\n").each do |line|
        nums = line.scan(/-?\d+/).map(&:to_i)

        coords << [Vector.new(*nums[0..1]), Vector.new(*nums[2..3])]
      end

      @rounds = 0
      loop do
        adjacient = coords.all? do |pos|
          dirs.any? do |dir|
            coords.any? do |c|
              (pos[0] + dir) == c[0]
            end
          end
        end

        break if adjacient

        coords = coords.map{|c| [ c[0] + c[1], c[1] ] }

        @rounds += 1
      end
      coords
    end
  end

  def self.part1
    coords = calc_coords

    minx = coords.min_by{|c| c[0][0] }[0][0]
    maxx = coords.max_by{|c| c[0][0] }[0][0]
    miny = coords.min_by{|c| c[0][1] }[0][1]
    maxy = coords.max_by{|c| c[0][1] }[0][1]

    (miny..maxy).each do |y|
      (minx..maxx).each do |x|
        pos = Vector.new(x, y)
        if coords.any?{|c| c[0] == pos }
          print "#"
        else
          print "."
        end
      end
      print "\n"
    end

    'EKALLKLB'
  end

  def self.part2
    calc_coords
    @rounds
  end
end

RSpec.describe "Day10" do
  it "does part 1" do
    expect(Day10.part1).to eq('EKALLKLB')
  end

  it "does part 2" do
    expect(Day10.part2).to eq(10227)
  end
end
