class Day08 < Helper
  def self.part1
    junctions = file.lines.map(&:numbers).map(&:to_vec3)

    distances = []
    junctions.keys.combination(2) do |j1i, j2i|
      j1 = junctions[j1i]
      j2 = junctions[j2i]
      distances << [j1i, j2i, j1.euclidean(j2)]
    end

    distances = distances.sort_by { _1[2] }
    circuits  = junctions.keys.to_h { [_1, { _1 => true }] }

    distances = distances[0, 1000]
    distances.each do |posa, posb, dist|
      circuits[posa][posb] = true
      circuits[posb][posa] = true
    end

    chains = {}
    circuits.each do |key, value|
      chains[key] = []

      queue = [key]
      seen = Set.new
      while queue.present?
        row = queue.shift
        next if seen.include?(row)
        seen << row

        chains[key] << row

        circuits[row].keys.each do |check|
          queue << check
        end
      end

      chains[key].sort!
    end

    chains.values.uniq.map(&:size).sort.reverse[0, 3].reduce(&:*)
  end

  def self.part2
    junctions = file.lines.map(&:numbers).map(&:to_vec3)

    distances = []
    junctions.keys.combination(2) do |j1i, j2i|
      j1 = junctions[j1i]
      j2 = junctions[j2i]
      distances << [j1i, j2i, j1.euclidean(j2)]
    end

    distances = distances.sort_by { _1[2] }
    circuits  = junctions.keys.to_h { [_1, { _1 => true }] }

    distances = distances
    distances.each do |posa, posb, dist|
      check = []
      if !circuits[posa][posb]
        circuits[posa][posb] = true
        check << posa
      end
      if !circuits[posb][posa]
        circuits[posb][posa] = true
        check << posb
      end

      check.map { circuits.linked_list(_1) }.each do |chain|
        next if chain.size < junctions.size

        return junctions[posa].x * junctions[posb].x
      end
    end
  end
end

# puts Day08.part1
puts Day08.part2
return

RSpec.describe "Day08" do
  it "does part 1" do
    expect(Day08.part1).to eq(164475)
  end

  it "does part 2" do
    expect(Day08.part2).to eq(169521198)
  end
end
