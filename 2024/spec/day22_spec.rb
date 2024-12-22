class Day22 < Helper
  @changes = {}

  def self.secret(value, round: 1, rounds: 10, base_value: value)
    new_value = value * 64
    value     = value ^ new_value
    value    %= 16777216

    new_value = (value / 32).floor
    value = value ^ new_value
    value %= 16777216

    new_value = value * 2048
    value = value ^ new_value
    value %= 16777216

    @changes[base_value] ||= [base_value]
    @changes[base_value] << value

    return secret(value, round: round + 1, rounds: rounds, base_value: base_value) if round < rounds

    value
  end

  def self.part1(nums = file.numbers, rounds = 2000)
    cache(nums, rounds) do
      nums.map { secret(_1, rounds: rounds) }.sum
    end
  end

  def self.part2
    part1

    highest = {}
    @changes.each do |key, value|
      @changes[key] = value.map { _1.to_s[-1].to_i }.each_cons(2).map { [_1[1], _1[1] - _1[0]] }

      seen = {}
      @changes[key].each_with_index do |(value, diff), vi|
        next if value < 1

        seq = @changes[key][vi - 3, 4].map { _1[1] }
        next if seq.count != 4

        next if seen[seq]
        seen[seq] = true

        highest[seq] ||= 0
        highest[seq] += value
      end
    end

    highest.max_by { _1[1] }[1]
  end
end

RSpec.describe "Day22" do
  it "does part 1" do
    expect(Day22.part1).to eq(19927218456)
  end

  it "does part 2" do
    expect(Day22.part2).to eq(2189)
  end
end