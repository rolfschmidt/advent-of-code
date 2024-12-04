
class Day04 < Helper
  def self.part1(part2 = false)
    input = file.to_2d
    result = 0
    input.each_with_index do |y, yi|
      y.each_with_index do |x, xi|

        right      = "#{input.pos(yi, xi)}#{input.pos(yi, xi+1)}#{input.pos(yi,xi+2)}#{input.pos(yi, xi+3)}"
        left       = "#{input.pos(yi, xi)}#{input.pos(yi, xi-1)}#{input.pos(yi,xi-2)}#{input.pos(yi, xi-3)}"
        up         = "#{input.pos(yi, xi)}#{input.pos(yi-1, xi)}#{input.pos(yi-2,xi)}#{input.pos(yi-3, xi)}"
        down       = "#{input.pos(yi, xi)}#{input.pos(yi+1, xi)}#{input.pos(yi+2,xi)}#{input.pos(yi+3, xi)}"
        right_down = "#{input.pos(yi, xi)}#{input.pos(yi+1, xi+1)}#{input.pos(yi+2,xi+2)}#{input.pos(yi+3, xi+3)}"
        left_up    = "#{input.pos(yi, xi)}#{input.pos(yi-1, xi-1)}#{input.pos(yi-2,xi-2)}#{input.pos(yi-3, xi-3)}"
        right_up   = "#{input.pos(yi, xi)}#{input.pos(yi-1, xi+1)}#{input.pos(yi-2,xi+2)}#{input.pos(yi-3, xi+3)}"
        left_down  = "#{input.pos(yi, xi)}#{input.pos(yi+1, xi-1)}#{input.pos(yi+2,xi-2)}#{input.pos(yi+3, xi-3)}"

        result += [right,left,up,down, right_down, left_up, right_up, left_down].count{|row| row == 'XMAS' }
      end
    end

    result
  end

  def self.part2
    input = file.to_2d
    result = 0
    input.each_with_index do |y, yi|
      y.each_with_index do |x, xi|
        left_down  = "#{input.pos(yi-1, xi-1)}#{input.pos(yi, xi)}#{input.pos(yi+1,xi+1)}"
        right_down = "#{input.pos(yi-1, xi+1)}#{input.pos(yi, xi)}#{input.pos(yi+1,xi-1)}"

        count = [left_down, right_down].count{|row| row == 'MAS' || row == 'SAM' }
        next if count < 2

        result += 1
      end
    end

    result
  end
end

RSpec.describe "Day04" do
  it "does part 1" do
    expect(Day04.part1).to eq(2534)
  end

  it "does part 2" do
    expect(Day04.part2).to eq(1866)
  end
end