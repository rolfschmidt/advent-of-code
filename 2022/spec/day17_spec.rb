class Day17 < Helper
  def self.jets
    @jets ||= file.split("").map do |j|
      if j == '>'
        Vector[1, 0]
      else
        Vector[-1, 0]
      end
    end
  end

  def self.move(map, rock, pos)
    new_rock = rock.clone
    new_rock.each_with_index do |_, i|
      new_rock[i] += pos

      return rock if new_rock[i][0] < 0
      return rock if new_rock[i][0] > 6
      return rock if new_rock[i][1] < 0
    end

    return rock if new_rock.any?{|pp| map[pp] }
    return new_rock
  end

  def self.part1(part2 = false)
    map    = {}
    height = 0
    jet    = 0
    cache  = {}

    rocks = [
      [Vector[0, 0], Vector[1, 0], Vector[2, 0], Vector[3, 0]],
      [Vector[1, 2], Vector[0, 1], Vector[1, 1], Vector[2, 1], Vector[1, 0]],
      [Vector[2, 2], Vector[2, 1], Vector[0, 0], Vector[1, 0], Vector[2, 0]],
      [Vector[0, 3], Vector[0, 2], Vector[0, 1], Vector[0, 0]],
      [Vector[0, 1], Vector[1, 1], Vector[0, 0], Vector[1, 0]],
    ]

    (part2 ? 1000000000000 : 2022).times do |rr|
      cache_key = [rr % rocks.size, jet]
      if cache[cache_key]
        rest_rounds = 1000000000000 - rr
        diff_rounds = rr - cache[cache_key][0]

        if rest_rounds % diff_rounds == 0
          return height + rest_rounds / diff_rounds * (height - cache[cache_key][1])
        end
      end
      cache[cache_key] = [rr, height]

      rock = rocks[rr % rocks.size].clone.map{|pp| pp += Vector[2, height + 3] }

      while true do
        rock = move(map, rock, jets[jet])
        jet  = (jet + 1) % jets.size

        new_rock = move(map, rock, Vector[0, -1])
        if rock == new_rock
          rock.each do |pos|
            map[pos] = true
            height    = [height, pos[1] + 1].max
          end

          break
        else
          rock = new_rock
        end
      end
    end

    height
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day17" do
  it "does part 1" do
    expect(Day17.part1).to eq(3181)
  end

  it "does part 2" do
    expect(Day17.part2).to eq(1570434782634)
  end
end
