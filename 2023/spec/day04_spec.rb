class Day04 < Helper
  def self.cards
    @cards ||= file.split("\n").map.with_index do |line, li|
      card, game = line.split(/:/)
      a1, a2 = game.split(/\|/)

      match = a2.numbers.count{|v| a1.numbers.include?(v) }
      match.times.each_with_object([]) do |r, result|
        result << li + r + 1
      end
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
    @cache ||= {}
    @cache[idx] ||= 1 + cards[idx].sum {|ci| count_cards(ci) }
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
