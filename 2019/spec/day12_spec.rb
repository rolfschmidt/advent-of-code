class Day12 < Helper
  def self.part1
    moons = file.lines.map(&:numbers).map do
      [_1.to_vec3, [0, 0, 0].to_vec3]
    end
    moons_orig = ddup(moons)
    lcms = {}

    step = 0
    loop do
      moons.combination(2).each do |m1, m2|
        (0..2).each do |axis|
          if m1[0][axis] < m2[0][axis]
            m1[1][axis] += 1
            m2[1][axis] -= 1
          elsif m1[0][axis] > m2[0][axis]
            m1[1][axis] -= 1
            m2[1][axis] += 1
          end
        end
      end

      moons.each do |mo|
        mo[0] += mo[1]
      end

      step += 1

      # save steps per axis (x,y,z) and lcm it when position matches orig
      if part2?
        (0..2).each do |axis|
          next if lcms[axis]
          next if moons.keys.any? { moons[_1][0][axis] != moons_orig[_1][0][axis] }

          lcms[axis] = step + 1
          return lcms.values.reduce(&:lcm) if lcms.size == 3
        end
      else
        break if step == 1000
      end
    end

    moons.sum do |mo|
      pote = mo[0].to_a.map(&:abs).sum
      kine = mo[1].to_a.map(&:abs).sum
      pote * kine
    end
  end

  def self.part2
    part1
  end
end

RSpec.describe "Day12" do
  it "does part 1" do
    expect(Day12.part1).to eq(7013)
  end

  it "does part 2" do
    expect(Day12.part2).to eq(324618307124784) # 614762850151322230512
  end
end
