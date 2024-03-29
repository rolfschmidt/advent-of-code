class Day07 < Helper
  def self.cards_points(cards, part2)
    cards_replaced = ddup(cards)
    types          = cards.tally.invert
    two_pairs      = cards.select{|c| cards.select{|cs| c == cs }.count == 2 }.uniq

    if part2 && cards.include?(1)
      types  = cards.reject{|c| c == 1 }.tally.invert
      jokers = cards.count(1)

      replace = types[types.keys.max] || cards_replaced.find{|c| c != 1 } || 1
      cards_replaced = cards_replaced.map do |c|
        next c if c != 1 || jokers == 0

        jokers -= 1
        replace
      end

      types     = cards_replaced.tally.invert
      two_pairs = cards_replaced.select{|c| cards_replaced.select{|cs| c == cs }.count == 2 }.uniq
    end

    base_value      = 10 ** (10 + 2 ** types.keys.max)
    base_two_pair   = types[2] && two_pairs.count > 1 ? 100 : 1
    base_full_house = types[3] && types[2] ? 100 : 1
    base_cards      = cards.map.with_index{|c, i| c * (10 ** (10 - i * 2)) }.sum

    (base_value * base_two_pair * base_full_house) + base_cards
  end

  def self.part1(part2 = false)
    players = file.split("\n").map do |line|
      data = line.split(" ")
      data[0] = data[0].chars.map do |c|
        case c
          when /\d/ then c.to_i
          when 'T' then 10
          when 'J' then (part2 ? 1 : 11)
          when 'Q' then 12
          when 'K' then 13
          when 'A' then 14
        end
      end
      data[1] = data[1].to_i
      data
    end

    count = 0
    players.sort do |a, b|
      cards_points(a[0], part2) <=> cards_points(b[0], part2)
    end.sum do |player|
      count += 1
      count * player[1]
    end
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day07" do
  it "does part 1" do # 251699200 251360343 250950623 251611021 251750938 251749358 250953867 250966720
    expect(Day07.part1).to eq(250946742)
  end

  it "does part 2" do
    expect(Day07.part2).to eq(251824095)
  end
end
