class Day08 < Helper
  def self.part1
    junctions = file.lines.map(&:numbers).map(&:to_vec3)
    distances = junctions.combination(2).map do |ja, jb|
      [ja, jb, ja.euclidean(jb)]
    end.sort_by {|js| js[2] }

    circuits  = junctions.map { [_1] }
    distances = distances[0, 1000] if !part2?
    distances.each do |posa, posb|
      alist = circuits.find { _1.include?(posa) }
      blist = circuits.find { _1.include?(posb) }
      next if alist == blist

      circuits.delete(alist)
      circuits.delete(blist)

      nlist = (alist | blist)
      return posa.x * posb.x if part2? && nlist.size == junctions.size

      circuits << nlist
    end

    circuits.sort_by(&:size).map(&:size)[-3..].reduce(&:*)
  end

  def self.part2
    part1
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
