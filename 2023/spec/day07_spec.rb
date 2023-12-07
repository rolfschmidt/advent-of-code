class Day07 < Helper
  def self.cards_points(cards, part2)
    cards_replaced = ddup(cards)
    types = cards.tally.invert
    two_pairs = cards.select{|c| cards.select{|cs| c == cs }.count == 2 }.uniq

    if part2 && cards.include?(1)
      types = cards.select{|c| c != 1 }.tally.invert
      jokers = cards.count(1)

      [4, 3, 2, nil].each do |type|
        next if type && !types[type]

        replace = if !type
                    cards_replaced.find{|c| c != 1 } || 1
                  else
                    types[type]
                  end

        cards_replaced = cards_replaced.map do |c|
          if c == 1 && jokers > 0
            jokers -= 1
            replace
          else
            c
          end
        end

        break
      end

      types     = cards_replaced.tally.invert
      two_pairs = cards_replaced.select{|c| cards_replaced.select{|cs| c == cs }.count == 2 }.uniq
    end

    bv = if types[5]
        1000000000000000000000000
      elsif types[4]
        10000000000000000000000
      elsif types[3] && types[2]
        100000000000000000000
      elsif types[3]
        1000000000000000000
      elsif types[2] && two_pairs.count > 1
        10000000000000000
      elsif types[2]
        100000000000000
      else
        1000000000000
      end

    bv + (cards[0] * 10000000000) + (cards[1] * 100000000) + (cards[2] * 1000000) + (cards[3] *10000) + (cards[4] * 100)
  end

  def self.part1(part2 = false)
    players = file.split("\n").map do |line|
      data = line.split(" ")
      {
        cards: data[0].chars.map {|c|
          if c =~ /\d/
            c.to_i
          elsif c == 'T'
            10
          elsif c == 'J'
            if part2
              1
            else
              11
            end
          elsif c == 'Q'
            12
          elsif c == 'K'
            13
          elsif c == 'A'
            14
          end
        },
        points: data[1].to_i,
      }
    end

    result = players.sort do |a, b|
      cards_points(a[:cards], part2) <=> cards_points(b[:cards], part2)
    end

    count = 0
    result.sum do |player|
      count += 1
      count * player[:points]
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
