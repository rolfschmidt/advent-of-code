class Day11 < Helper
  def self.part1(part2 = false)
    x = 0
    y = 0
    z = 0
    dists = []
    file.split(",").each do |ds|
      case ds
      when 'n'
        y += 1
        z -= 1
      when 'ne'
        x += 1
        z -= 1
      when 'se'
        x += 1
        y -= 1
      when 's'
        y -= 1
        z += 1
      when 'sw'
        x -= 1
        z += 1
      when 'nw'
        x -= 1
        y += 1
      else
        raise
      end
      dists.append((x.abs + y.abs + z.abs) / 2)
    end

    return dists.max if part2

    (x.abs + y.abs + z.abs) / 2
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day11" do
  it "does part 1" do
    expect(Day11.part1).to eq(720)
  end

  it "does part 2" do
    expect(Day11.part2).to eq(1485)
  end
end