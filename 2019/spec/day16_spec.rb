class Day16 < Helper
  def self.part1
    pattern       = [0, 1, 0, -1]
    pattern_count = [1, 1, 1, 1]
    nums          = file.chars.map(&:to_i)

    100.times do |round|
      phase = []
      nums.each_with_index do |nv, ni|
        pi = 0
        pattern.keys.each { pattern_count[_1] = ni + 1 }
        pattern_count[0] = 0 if ni == 0

        line_count = 0
        nums.each_with_index do |nv2, ni2|
          pattern_count[pi % pattern.size] -= 1
          if pattern_count[pi % pattern.size] <= 0
            pi += 1
            pattern_count[(pi - 1) % pattern.size] = ni + 1
            pattern_count[0] = 0 if ni == 0
          end

          pv = pattern[pi % pattern.size]
          line_count += nv2 * pv
        end

        line_count = line_count.abs % 10
        phase << line_count
      end

      nums = phase
      return phase.join[...8].to_i if (round + 1) == 100
    end
  end

  def self.part2
    input = file.chars.map(&:to_i)
    offset = input[0,7].join.to_i

    nums = (input * 10_000)[offset..]

    100.times do
      sum = 0
      (nums.length - 1).downto(0) do |i|
        sum += nums[i]
        nums[i] = sum % 10
      end
    end

    nums[0,8].join.to_i
  end
end

RSpec.describe "Day16" do
  it "does part 1" do
    expect(Day16.part1).to eq(68764632)
  end

  it "does part 2" do
    expect(Day16.part2).to eq(52825021)
  end
end
