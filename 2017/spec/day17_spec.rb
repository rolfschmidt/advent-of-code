class Day17 < Helper
  def self.part1
    steps = file.to_i
    rounds = 2017

    list = [0]
    counter = 1
    idx = 0
    rounds.times do |r|
      idx = (idx + steps) % list.size

      idx += 1
      list.insert(idx, counter)

      counter += 1
    end

    list[(list.index(2017) + 1) % list.size]
  end

  def self.part2
    steps = file.to_i
    rounds = 50000000

    size = 1
    counter = 1
    idx = 0
    value = nil
    rounds.times do |r|
      idx = (idx + steps) % size

      idx += 1
      size += 1
      if idx == 1
        value = counter
      end

      counter += 1
    end

    value
  end
end

RSpec.describe "Day17" do
  it "does part 1" do
    expect(Day17.part1).to eq(1306)
  end

  it "does part 2" do # 317809
    expect(Day17.part2).to eq(20430489)
  end
end