class Day04 < Helper
  def self.part1
    map    = file.to_map
    result = 0
    until_stable do
      map.select_value('@').keys.each do |pos|
        neighbours = DIRS_ALL.count do |dir|
          map[pos + dir] == '@'
        end

        next if neighbours >= 4

        result += 1
        map.delete(pos)
        stable if part2?
      end
    end

    result
  end

  def self.part2
    part1
  end
end

RSpec.describe "Day04" do
  it "does part 1" do
    expect(Day04.part1).to eq(3053)
  end

  it "does part 2" do
    expect(Day04.part2).to eq(8899)
  end
end
