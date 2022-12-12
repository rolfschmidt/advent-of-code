Square = Struct.new(:x, :y, :name) do
  attr_accessor :neighbours

  def height
    return 'a'.ord - 96 if name == 'S'
    return 'z'.ord - 96 + 1 if name == 'E'
    return name.ord - 96
  end

  def neighbours(matrix)
    return @neighbours if !@neighbours.nil?

    @neighbours = []
    [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1],
    ].each do |d|
      new_pos = [x + d[0], y + d[1]]
      next if new_pos[0] < 0
      next if new_pos[1] < 0

      new_pos = matrix.dig(new_pos[1], new_pos[0])
      next if new_pos.blank?
      next if new_pos.height > height + 1

      @neighbours << new_pos
    end

    @neighbours
  end

  def self.count_from(matrix, start)
    seen  = {}
    queue = [[start, 0]]
    while queue.present?
      node, count = queue.shift

      next if seen[node]
      seen[node] = true

      return count if node.name == 'E'

      node.neighbours(matrix).each do |sub_node|
        queue.push([sub_node, count + 1])
      end
    end
  end
end

class Day12 < Helper
  def self.part1(part2 = false)
    matrix = []
    file.split("\n").map{|v| v.split("") }.each_with_index do |r, y|
      matrix << r.map.with_index {|c, x| Square.new(x, y, c) }
    end

    return matrix.flatten.select{|s| s.name == 'a' }.map{|n| Square.count_from(matrix, n) }.compact.min if part2

    Square.count_from(matrix, matrix.flatten.find{|n| n.name == 'S'})
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day12" do
  it "does part 1" do
    expect(Day12.part1).to eq(361)
  end

  it "does part 2" do
    expect(Day12.part2).to eq(354)
  end
end