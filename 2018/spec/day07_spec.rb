class Day07 < Helper
  def self.init_map
    map = {}
    file.split("\n").each do |line|
      chars = line.scan(/\s\w\s/).map(&:strip)

      map[chars[0]] ||= []
      map[chars[1]] ||= []
      map[chars[1]] << chars[0]
    end
    map
  end

  def self.part1
    map = init_map

    result = ''
    while true
      chars = map.keys.sort

      free = chars.detect{|c| map[c].blank? }
      break if free.blank?

      map.each do |key, value|
        map[key] = map[key] - [free]
      end

      result += free
      map.delete(free)
    end

    result
  end

  def self.part2
    map = init_map

    worker_count = 5
    worker_char = {}
    worker_time = {}

    result     = ''
    total_time = 0
    step = 60
    while map.present? do
      worker_count.times do |wid|
        if worker_char[wid].present?
          if worker_time[wid] == total_time
            free = worker_char[wid]

            map.each do |key, value|
              map[key] = map[key] - [free]
            end

            result += free
            map.delete(free)

            worker_char.delete(wid)
            worker_time.delete(wid)
          end
        end
      end

      worker_count.times do |wid|
        next if worker_char[wid]

        chars = map.keys.sort

        free = chars.detect{|c| map[c].blank? && worker_char.values.exclude?(c) }
        break if free.blank?

        worker_char[wid] = free
        worker_time[wid] = total_time + free.ord - 64 + step
      end

      total_time += 1
    end

    total_time - 1
  end
end

RSpec.describe "Day07" do
  it "does part 1" do
    expect(Day07.part1).to eq('LFMNJRTQVZCHIABKPXYEUGWDSO')
  end

  it "does part 2" do
    expect(Day07.part2).to eq(1180) # 16319 16260 13440
  end
end
