
class Day09 < Helper
  def self.part1(chain_count = 2)
    chains  = chain_count.times.map { Vector[0, 0] }
    checked = (0..chains.count - 1).map {|i| [i,[Vector[0, 0]]] }.to_h
    move    = {
      "R" => Vector[1, 0],
      "L" => Vector[-1, 0],
      "U" => Vector[0, 1],
      "D" => Vector[0, -1]
    }

    file.split("\n").each_with_index do |line, i|
      d, c = line.split(" ")

      c.to_i.times do |t|
        chains[0] += move[d]
        checked[0].unshift(chains[0].clone)

        (1..chains.size - 1).each do |i|
          ca = chains[i - 1]
          cb = chains[i]

          next if (ca - cb).magnitude < 2

          if ca[0] > cb[0]
            cb[0] += 1
          elsif ca[0] < cb[0]
            cb[0] -= 1
          end

          if ca[1] > cb[1]
            cb[1] += 1
          elsif ca[1] < cb[1]
            cb[1] -= 1
          end

          checked[i].unshift(cb.clone)
        end
      end
    end

    return checked[chains.count - 1].uniq.count
  end

  def self.part2
    part1(10)
  end
end

RSpec.describe "Day09" do
  it "does part 1" do
    expect(Day09.part1).to eq(6037)
  end

  it "does part 2" do
    expect(Day09.part2).to eq(2485)
  end
end