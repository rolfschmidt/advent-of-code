class Day06 < Helper
  def self.part1(part2 = false)
    map = {}
    file.split("\n").each do |line|
      task  = line.scan(/(?:on|off|toggle)/).first
      pos   = line.numbers
      start = pos[0..1]
      stop  = pos[2..3]

      (start[0]..stop[0]).each do |x|
        (start[1]..stop[1]).each do |y|
          key = "#{x}_#{y}"
          if part2
            map[key] ||= 0
            if task == 'on'
              map[key] += 1
            elsif task == 'off'
              map[key] = [0, map[key] - 1].max
            elsif task == 'toggle'
              map[key] += 2
            end
          else
            if task == 'on'
              map[key] = true
            elsif task == 'off'
              map[key] = false
            elsif task == 'toggle'
              if !map.key?(key)
                map[key] = false
              end

              map[key] = !map[key]
            end
          end
        end
      end
    end

    return map.values.sum if part2

    map.select{|k, v| v == true }.count
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day06" do
  it "does part 1" do
    expect(Day06.part1).to eq(569999)
  end

  it "does part 2" do
    expect(Day06.part2).to eq(17836115)
  end
end
