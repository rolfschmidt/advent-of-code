class Day09 < Helper
  def self.part1(part2 = false)
    player_count, rounds = file.scan(/\d+/).map(&:to_i)

    if part2
      rounds *= 100
    end

    players = [0] * player_count
    pos = Node.new(0)
    rounds.times do |r|
      rv = r + 1
      pi = r % players.size

      if rv % 23 != 0
        pos = pos.next
        pos = pos.insert(rv)
      else
        players[pi] += rv

        6.times do
          pos = pos.prev
        end

        players[pi] += pos.prev.delete
      end
    end

    players.max
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day09" do
  it "does part 1" do
    expect(Day09.part1).to eq(370210) # 161 102786 100985
  end

  it "does part 2" do
    expect(Day09.part2).to eq(3101176548)
  end
end
