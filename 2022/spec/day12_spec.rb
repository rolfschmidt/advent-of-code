Square = Struct.new(:x, :y, :name) do
  attr_accessor :neighbours

  def height
    return 'a'.ord - 96 if name == 'S'
    return 'z'.ord - 96 + 1 if name == 'E'
    return name.ord - 96
  end

  def neighbours(matrix)
    @neighbours ||= begin
      [
        [x + -1, y],
        [x + 1, y],
        [x, y + -1],
        [x, y + 1],
      ].each_with_object([]) do |pos, result|
        next if pos.any?(&:negative?)

        pos = matrix.dig(pos[1], pos[0])
        next if pos.blank?
        next if pos.height > height + 1

        result << pos
      end
    end
  end

  def self.count_from(matrix, start)
    seen  = {}
    queue = [[start, 0]]
    while queue.present?
      node, count = queue.shift

      next if seen[node]
      seen[node] = true

      return count if node.name == 'E'

      node.neighbours(matrix).each do |n|
        queue.push([n, count + 1])
      end
    end
  end
end

class Day12 < Helper
  def self.part1(part2 = false)
    matrix = file.to_2d.map.with_index do |yv, y|
      yv.map.with_index {|xv, x| Square.new(x, y, xv) }
    end

    return matrix.flatten.select{|n| n.name == 'a' }.map{|n| Square.count_from(matrix, n) }.compact.min if part2

    Square.count_from(matrix, matrix.flatten.detect{|n| n.name == 'S'})
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
