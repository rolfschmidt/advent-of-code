class Day08 < Helper
  def self.part1(part2 = false)
    matrix = file.split("\n").map{|x| x.split("").map(&:to_i) }

    maxx = matrix[0].count - 1
    maxy = matrix.count - 1

    count     = 0
    max_score = 0
    matrix.each_with_index do |vy, yi|
      vy.each_with_index do |xv, xi|
        if yi == maxy || yi == 0 || xi == 0 || xi == maxx
          count += 1
          next
        end

        top          = false
        bottom       = false
        left         = false
        right        = false
        count_top    = 0
        count_bottom = 0
        count_left   = 0
        count_right  = 0

        (0..yi - 1).to_a.reverse.each do |ci|
          count_top += 1
          if matrix[ci][xi] >= xv
            top = false
            break
          end

          top = true
        end
        (yi + 1..maxy).to_a.each do |ci|
          count_bottom += 1
          if matrix[ci][xi] >= xv
            bottom = false
            break
          end

          bottom = true
        end
        (0..xi - 1).to_a.reverse.each do |ci|
          count_left += 1
          if matrix[yi][ci] >= xv
            left = false
            break
          end

          left = true
        end
        (xi + 1..maxx).to_a.each do |ci|
          count_right += 1
          if matrix[yi][ci] >= xv
            right = false
            break
          end

          right = true
        end

        if top || bottom || left || right
          count    += 1
          score     = count_top * count_bottom * count_left * count_right
          max_score = [score, max_score].max
        end
      end
    end

    return max_score if part2

    count
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day08" do
  it "does part 1" do
    expect(Day08.part1).to eq(1840)
  end

  it "does part 2" do
    expect(Day08.part2).to eq(405769)
  end
end