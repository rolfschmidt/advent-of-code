class Day14 < Helper
  def self.list
    @list ||= begin
      file.split("\n").map do |line|
        line.numbers
      end
    end
  end

  def self.dist(total_time, speed, travel, rest)
    q, r = total_time.divmod(travel + rest)
    (q * travel + [r, travel].min) * speed
  end

  def self.part1
    list.map do |player|
      speed, travel, rest = player

      dist(2503, speed, travel, rest)
    end.max
  end

  def self.part2
    stats = {}
    (1..2503).each do |total_time|
      players = list.map.with_index do |p, pi|
        speed, travel, rest = p

        [pi, dist(total_time, speed, travel, rest)]
      end

      max = players.max_by{|v| v[1] }[1]
      players.each do |p|
        stats[p[0]] ||= 0
        stats[p[0]] += (p[1] == max ? 1 : 0)
      end
    end

    stats.values.max
  end
end

RSpec.describe "Day14" do
  it "does part 1" do
    expect(Day14.part1).to eq(2696)
  end

  it "does part 2" do
    expect(Day14.part2).to eq(1084)
  end
end