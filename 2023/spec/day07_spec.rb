class Day07 < Helper
  def self.cards_points(cards)
    types = cards.tally.invert
    two_pairs = cards.select{|c| cards.select{|cs| c == cs }.count == 2 }.uniq
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

  def self.parse_card(cards)
    counts = cards.tally.invert
    types = cards.tally.invert
    if types[5]
      [5, types[5]]
    elsif types[4]
      [4, types[4]]
    elsif types[3] && types[2]
      [3.2, types[3], types[2]]
    elsif types[3]
      [3, types[3]]
    elsif types[2]
      two_pairs = cards.select{|c| cards.select{|cs| c == cs }.count == 2 }.uniq
      return [2, two_pairs.max, two_pairs.min] if two_pairs.count > 1
      return [2, two_pairs.max]
    else
      [1, cards.max]
    end
  end

  def self.part1
    players = file.split("\n").map do |line|
      data = line.split(" ")
      {
        cards: data[0].chars.map {|c|
          if c =~ /\d/
            c.to_i
          elsif c == 'T'
            10
          elsif c == 'J'
            11
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
      cards_points(a[:cards]) <=> cards_points(b[:cards])
    end

    count = 1
    total = 0
    result.each do |player|
      total += count * player[:points]
      count += 1

    end

    total
  end

  def self.part2
    100
  end
end


RSpec.describe "Day07" do
  it "does part 1" do # 251699200 251360343 250950623 251611021 251750938 251749358 250953867 250966720
    expect(Day07.part1).to eq(250946742)
  end

  # it "does part 2" do
  #   expect(Day07.part2).to eq(100)
  # end
end
