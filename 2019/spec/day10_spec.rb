class Day10 < Helper
  def self.map
    @map ||= file.to_map
  end

  def self.asteroids
    @asteroids ||= map.select_value('#').keys
  end

  def self.totals
    @totals ||= begin
      totals    = {}
      asteroids.each do |from|
        totals[from] = asteroids.map { from.can_see?(_1, asteroids).to_i }.sum
      end
      totals
    end
  end

  def self.part1
    totals.values.max - 1
  end

  def self.part2
    best = totals.find {|k, v| v == totals.values.max }.first

    targets = asteroids.map do |pos|
      { pos: pos, angle: best.angle_with(pos), dist: pos.manhattan(best) }
    end

    grouped = targets.group_by { |t| t[:angle] }
    grouped.each { |angle, list| list.sort_by! { |t| t[:dist] } }

    sorted_angles = grouped.keys.sort
    vaporized_count = 0
    result_asteroid = nil

    until vaporized_count == 200 || grouped.empty?
      sorted_angles.each do |angle|
        next unless grouped[angle] && !grouped[angle].empty?

        target = grouped[angle].shift
        vaporized_count += 1

        if vaporized_count == 200
          result_asteroid = target
          break
        end
      end
    end

    result_asteroid[:pos].x * 100 + result_asteroid[:pos].y
  end
end

RSpec.describe "Day10" do
  it "does part 1" do
    expect(Day10.part1).to eq(278)
  end

  it "does part 2" do
    expect(Day10.part2).to eq(1417)
  end
end
