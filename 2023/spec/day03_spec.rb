class Day03 < Helper
  def self.part1(part2 = false)
    matrix = []
    file.split("\n").map(&:chars).each do |line|
      matrix << line
    end

    checked = {}
    neighbours = {}

    count = 0

    matrix.each_with_index do |y, yi|
      matrix[yi].each_with_index do |x, xi|
        next if !x.is_number?
        next if checked[[yi, xi]]

        neighbour = nil

        match = false
        [-1, 0, 1].each do |dx|
          [-1, 0, 1].each do |dy|
            next if dx == 0 && dy == 0

            nx = xi + dx
            ny = yi + dy
            next if !matrix.bounded?(x: nx, y: ny)

            val = matrix[ny][nx]
            next if val.is_number? || val == '.'

            match = true
            neighbour = [ny, nx]
          end
        end

        mx = [xi]

        num = x
        cx  = xi
        loop do
          cx -= 1
          break if !matrix.bounded?(x: cx)
          break if checked[[yi, cx]]

          val = matrix[yi][cx]
          break if !val.is_number?

          num = "#{val}#{num}"
          mx << cx
        end

        cx  = xi
        loop do
          cx += 1
          break if !matrix.bounded?(x: cx)
          break if checked[[yi, cx]]

          val = matrix[yi][cx]
          break if !val.is_number?

          num = "#{num}#{val}"
          mx << cx
        end


        if match
          count += num.to_i

          mx.each do |rx|
            checked[[yi, rx]] = true
          end

          neighbours[neighbour] ||= []
          neighbours[neighbour] << num.to_i
        end
      end
    end

    return neighbours.values.select{|v| v.count == 2 }.map{|v| v[0] * v[1] }.sum if part2

    count
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day03" do
  it "does part 1" do
    expect(Day03.part1).to eq(522726)
  end

  it "does part 2" do
    expect(Day03.part2).to eq(81721933)
  end
end
