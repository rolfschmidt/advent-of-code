class Day16 < Helper
  def self.edges
    @edges ||= begin
      r = []
      @valves.each do |v|
        v[2].each do |v2|
          next if v[0] == v2

          r << [v[0], v2, 1]
        end
      end
      r
    end
  end

  def self.valve_distances(from)
    @valve_distances ||= {}
    @valve_distances[from] ||= begin
      result = []
      @valves.each do |v|
        next if v[0] == from

        graph = Dijkstra::Trace.new(edges)
        path  = graph.path(from, v[0])

        result << path
      end
      result
        .sort_by {|r| r.distance }
        .map{|d| [d.ending_point, d.distance] }
        .select{|d| @valvesh[d[0]][1] > 0 }
    end
  end

  def self.search(time, valve, opened)
    cache_key = [time, valve, opened.sort]

    @cache ||= {}
    return @cache[cache_key] if @cache[cache_key]

    maxval = 0
    valve_distances(valve).each do |sub_name, sub_dist|
      sub_name = sub_name
      next if opened.include?(sub_name)

      remaining_time = time - sub_dist - 1
      next if remaining_time <= 0

      sub_maxval = search(remaining_time, sub_name, opened + [sub_name]) + @valvesh[sub_name][1] * remaining_time

      maxval = [maxval, sub_maxval].max
    end

    @cache[cache_key] = maxval

    return maxval
  end

  def self.parse
    @valves  = []
    @valvesh = {}

    start = 'AA'
    file.chomp.split("\n").each do |line|
      name, rate, to_valves = line.scan(/Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)/).flatten

      to_valves = to_valves.split(", ")
      valve     = [name, rate.to_i, to_valves]

      @valves << valve
      @valvesh[name] = valve
    end
  end

  def self.part1
    parse

    search(30, "AA", [])
  end

  def self.part2
    parse

    # always add AA so size is equal
    rated_valves = @valves.select{|v| v[1] > 0 || v[0] == 'AA' }.map{|v| v[0] }

    best = 0
    rated_valves.combination(rated_valves.count / 2).each do |g1|
      rated_valves.combination(rated_valves.count / 2).each do |g2|
        next if (g1 & g2).present?

        a    = search(26, "AA", g1.sort)
        b    = search(26, "AA", g2.sort)
        best = [best, a + b].max
      end
    end

    best
  end
end

RSpec.describe "Day16" do
  it "does part 1" do
    expect(Day16.part1).to eq(1751)
  end

  it "does part 2" do
    expect(Day16.part2).to eq(2207)
  end
end
