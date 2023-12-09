class Day10 < Helper
  def self.look_and_say(seed)
    previous = ''
    current  = seed[0]
    count    = 0
    final    = ''
    seed.each_char do |char|
      if char != current
        previous = current
        current  = char
        final   << count.to_s + previous
        count    = 0
      end
      count += 1
    end

    final << count.to_s + current

    return final
  end

  def self.part1(rounds = 40)
    seed = file.chomp
    @cache ||= {}
    rounds.times do |i|
      @cache[i] ||= look_and_say(seed)
      seed = @cache[i]
    end
    seed.length
  end

  def self.part2
    part1(50)
  end
end

RSpec.describe "Day10" do
  it "does part 1" do
    expect(Day10.part1).to eq(329356)
  end

  it "does part 2" do
    expect(Day10.part2).to eq(4666278)
  end
end
