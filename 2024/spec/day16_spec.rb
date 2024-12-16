class Day16 < Helper
  def self.shortest_way(map, start, stop)
    lowest_score = nil
    score_seen   = {}
    total_seen   = Set.new
    stop_on = -> (map:, pos:, path:, seen:, data:) do
      next if lowest_score.present? && lowest_score < data[:score]

      print "."
      total_seen   = Set.new if lowest_score != data[:score]
      lowest_score = data[:score]
      total_seen  += path.to_set
      return [lowest_score, path, seen]
    end

    skip_on = -> (map:, pos:, dir:, path:, seen:, data:) do
      next true if map[pos] == '#'

      if data[:last_dir] == dir
        data[:score] += 1
      else
        data[:score] += 1001
      end

      next true if lowest_score && lowest_score < data[:score]

      ss_key = "#{pos}_#{dir}"
      next true if score_seen[ss_key] && score_seen[ss_key] < data[:score]
      score_seen[ss_key] = data[:score]

      data[:last_dir] = dir

      false
    end

    map.shortest_path(start, stop, stop_on: stop_on, skip_on: skip_on, data: { last_dir: DIR_RIGHT, score: 0 })

    {
      min: lowest_score,
      seen: total_seen,
    }
  end

  def self.part1(part2 = false)
    map   = file.to_map
    start = map.select_value('S').keys.first
    stop  = map.select_value('E').keys.first

    @result ||= shortest_way(map, start, stop)

    return @result[:min] if !part2
    return @result[:seen].to_a.count
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day16" do
  it "does part 1" do
    expect(Day16.part1).to eq(109496)
  end

  it "does part 2" do
    expect(Day16.part2).to eq(551)
  end
end