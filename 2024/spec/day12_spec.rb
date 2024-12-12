class Day12 < Helper
  def self.part1(part2 = false)
    map = file_test.to_map

    areas = []
    seen  = Set.new
    map.each do |pos, value|
      next if seen.include?(pos)

      result = map.flood(pos)

      areas |= [result]
      seen += result
    end

    opposite_dirs = {
      DIR_UP => [DIR_LEFT, DIR_RIGHT],
      DIR_DOWN => [DIR_LEFT, DIR_RIGHT],
      DIR_RIGHT => [DIR_UP, DIR_DOWN],
      DIR_LEFT => [DIR_UP, DIR_DOWN],
    }

    result = 0
    areas.each do |area|
      perimeter = map.area_edges(area)

      perimeter_uniq   = []
      perimeter_search = perimeter.dup.to_a
      while perimeter_search.present? do
        rowa = perimeter_search.shift
        posa, dira = rowa

        opposite_dirs[dira].each do |search_dir|
          (1..1000000000000).each do |step|
            rowl = [posa + (search_dir * step), dira]

            if perimeter_search.include?(rowl)
              perimeter_search = perimeter_search.select{ _1 != rowl }
            else
              break
            end
          end
        end

        perimeter_uniq << rowa
      end

      if part2
        result += area.count * perimeter_uniq.count
      else
        result += area.count * perimeter.count
      end
    end

    result
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day12" do
  it "does part 1" do
    expect(Day12.part1).to eq(1381056)
  end

  it "does part 2" do
    expect(Day12.part2).to eq(834828) # 828594 839063
  end
end