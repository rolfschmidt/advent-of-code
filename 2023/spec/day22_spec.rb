class Day22 < Helper
  def self.fall(fall_rain)
    last_bi = 0
    maxi = fall_rain.size - 1
    counter = []
    loop do
      moved = false
      (last_bi..maxi).each do |b1i|
        b1 = fall_rain[b1i]
        next if b1.fz <= 1

        b1n = Vector3.new(b1.fx, b1.fy, b1.fz - 1, b1.tx, b1.ty, b1.tz - 1)
        next if (0..b1i - 1).to_a.reverse.any? do |bci|
          bc = fall_rain[bci]
          next if bc == b1
          next if bci > b1i
          next if !bc.overlaps?(b1n)
          true
        end

        fall_rain[b1i] = b1n
        last_bi = b1i

        moved = true
        counter << b1i
        break
      end

      break if !moved
    end

    [fall_rain, counter.uniq.count]
  end

  def self.rain
    @rain ||= begin
      rain = file.split("\n").map{|v| Vector3.new(*v.numbers) }
      rain = rain.sort_by{|v| v.fz }

      fall(rain).first
    end
  end

  def self.unstable_bricks
    @unstable_bricks ||= begin
      total_moved = []
      rain.combination(rain.count - 1).each do |combo_rain|
        moved = false
        combo_rain.each_with_index do |b1, b1i|
          next if b1.fz <= 1

          b1n = Vector3.new(b1.fx, b1.fy, b1.fz - 1, b1.tx, b1.ty, b1.tz - 1)

          next if (0..b1i - 1).to_a.reverse.any? do |bci|
            bc = combo_rain[bci]
            next if bc == b1
            next if !bc.overlaps?(b1n)
            true
          end

          moved = true
          break
        end

        next if !moved

        total_moved << rain.find{|v1| combo_rain.none?{|v2| v1 == v2 } }
      end
      total_moved
    end
  end

  def self.part1
    return rain.count - unstable_bricks.count
  end

  def self.part2
    total = 0
    unstable_bricks.map{|b| rain.index(b) }.each do |ui|
      combo_rain = rain - [rain[ui]]

      total += fall(combo_rain).second
    end

    return total
  end
end

RSpec.describe "Day22" do
  it "does part 1" do
    expect(Day22.part1).to eq(473)
  end

  it "does part 2" do # 3182
    expect(Day22.part2).to eq(61045)
  end
end