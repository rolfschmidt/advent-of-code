class Day04 < Helper
  def self.part1(part2 = false)
    id    = nil
    start = nil
    guards = {}
    sleepy = {}
    file.split("\n").sort.each do |line|
      line = line.tr('[', '').split('] ')

      if id && start && (line[1].include?('shift') || line[1].include?('wakes up'))
        stop = Time.parse(line[0])
        guards[id] ||= 0
        diff = ((stop - start) / 60).to_i
        guards[id] += diff

        (0..diff).each do |minute|
          minute = (start.min + minute) % 60
          sleepy[id] ||= {}
          sleepy[id][minute] ||= 0
          sleepy[id][minute] += 1
        end
      end

      if line[1] =~ /\#(\d+)/
        id = $1.to_i
      end

      if line[1].include?('shift') || line[1].include?('wakes up')
        start = nil
      elsif line[1].include?('falls asleep')
        start = Time.parse(line[0])
      end
    end

    id_max = guards.max_by{|v| v[1] }[0]
    min_max = sleepy[id_max].max_by{|v| v[1] }[0]

    if part2
      total_min_max = 0
      sleepy.keys.each do |gi|
        sleepy[gi].each do |minute, count|
          cur_max = count
          cur_id  = id_max
          sleepy.keys.each do |gid|
            if (sleepy[gid][minute] || 0) > cur_max
              cur_max = sleepy[gid][minute]
              cur_id = gid
            end
          end

          if cur_max > total_min_max
            total_min_max = cur_max
            min_max       = minute
            id_max        = cur_id
          end
        end
      end
    end

    id_max * min_max
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day04" do
  it "does part 1" do
    expect(Day04.part1).to eq(138280)
  end

  it "does part 2" do
    expect(Day04.part2).to eq(89347) # 91248
  end
end
