class Day04 < Helper
  def self.cards
    @cards ||= file.split("\n").map.with_index do |line, li|
      card, game = line.split(/:/)
      a1, a2 = game.split(/\|/)

      a1 = a1.scan(/\d+/).map(&:to_i)
      a2 = a2.scan(/\d+/).map(&:to_i)

      points = 0
      match = a2.count{|v| a1.include?(v) }

      result = []
      match.times do |r|
        result << li + r + 1
      end

      result
    end
  end


  def self.part1
    cards.sum do |card|
      points = 0
      card.count.times do
        if points > 0
          points *= 2
        else
          points = 1
        end
      end
      points
    end
  end

  def self.count_cards(idx)
    return 0 if !cards[idx]

    @cache ||= {}
    return @cache[idx] if @cache[idx]

    count = 1
    cards[idx].each do |ci|
      count += count_cards(ci)
    end

    @cache[idx] = count

    count
  end

  def self.part2
    cards.map.with_index {|c, ci| count_cards(ci) }.sum
  end
end

RSpec.describe "Day04" do
  it "does part 1" do # 12887
    expect(Day04.part1).to eq(25571)
  end

  it "does part 2" do
    expect(Day04.part2).to eq(8805731)
  end
end
