class Day08 < Helper
  def self.part1
    junctions = file.lines.map(&:numbers).map(&:to_vec3)
    distances = junctions.keys.combination(2).map do |i1, i2|
      [i1, i2, junctions[i1].euclidean(junctions[i2])]
    end.sort_by { _1[2] }

    circuits  = junctions.keys.to_h { [_1, { _1 => true }] }
    distances[0, 1000].each do |posa, posb, dist|
      circuits[posa][posb] = true
      circuits[posb][posa] = true
    end

    junctions.keys.map { circuits.linked_list(_1).sort }.uniq.sort_by(&:size)[-3..].map(&:size).reduce(&:*)
  end

  def self.check_max(junctions, circuits, pos)
    count = circuits.linked_count(pos)
    return if count < junctions.size
    return true
  end

  def self.part2
    junctions = file.lines.map(&:numbers).map(&:to_vec3)
    distances = junctions.keys.combination(2).map do |i1, i2|
      [i1, i2, junctions[i1].euclidean(junctions[i2])]
    end.sort_by { _1[2] }

    circuits  = junctions.keys.to_h { [_1, { _1 => true }] }
    distances.each do |posa, posb, dist|
      if !circuits[posa][posb]
        circuits[posa][posb] = true
        max = check_max(junctions, circuits, posa)
        return junctions[posa].x * junctions[posb].x if max
      end
      if !circuits[posb][posa]
        circuits[posb][posa] = true
        max = check_max(junctions, circuits, posb)
        return junctions[posa].x * junctions[posb].x if max
      end
    end
  end
end

RSpec.describe "Day08" do
  it "does part 1" do
    expect(Day08.part1).to eq(164475)
  end

  it "does part 2" do
    expect(Day08.part2).to eq(169521198)
  end
end
