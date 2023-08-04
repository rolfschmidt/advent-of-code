class Day21 < Helper
  @cache = {}

  def self.variants(grid)
    @cache[grid] ||= begin
      result = [grid]
      result << grid.reverse
      result << grid.map(&:reverse)
      result << grid.transpose
      result << grid.transpose.reverse
      result << grid.transpose.map(&:reverse)
      result << grid.reverse.map(&:reverse)
      result << grid.transpose.map(&:reverse).reverse
      result
    end
  end

  def self.print_variants(grid)
    variants(grid).each do |grid|
      print_grid(grid)
    end
  end

  def self.print_grid(grid)
    puts grid.map(&:join).join("\n")
    puts
  end

  def self.rules
    @rules ||= file.split("\n").map{|v| v.split(" => ").map{|v2| v2.split("/").map(&:chars) } }
  end

  def self.rule_match?(rule, map)
    variants(map).any?{|m| m == rule }
  end

  def self.run_rules(map)
    match = false
    rules.each do |rule|
      next if !rule_match?(rule[0], map)

      map = rule[1]
      match = true

      break
    end

    # raise map if !match

    map
  end

  def self.part1(rounds = 5)
    map = ".#.\n..#\n###".split("\n").map(&:chars)

    rounds.times do |r|
      # puts ""
      puts "round #{r}"

      steps = 3
      if map.size % 2 == 0
        steps = 2
      end

      map_size = map.size
      row_size = map.first.size
      y = 0
      x = 0
      yi = {}
      (map_size / steps).times do
        addy = 0
        (row_size / steps).times do
          check = []
          steps.times do |sy|
            row = []
            steps.times do |sx|
              row << map[y + sy][x + sx]
            end
            check << row
          end

          ruled = run_rules(check)
          if ruled.size == 4
            3.times do |ry|
              3.times do |rx|
                map[y + ry][x + rx] = ruled[ry][rx]
              end
              map[y + ry].insert(x + 3, ruled[ry][3])
            end
            if !yi[y + 3]
              map.insert(y + 3, ruled[3])
              yi[y + 3] = true
            else
              map[y + 3] += ruled[3]
            end

            x += 4
            addy = 4
          elsif ruled.size == 3
            2.times do |ry|
              2.times do |rx|
                map[y + ry][x + rx] = ruled[ry][rx]
              end
              map[y + ry].insert(x + 2, ruled[ry][2])
            end
            if !yi[y + 2]
              map.insert(y + 2, ruled[2])
              yi[y + 2] = true
            else
              map[y + 2] += ruled[2]
            end

            x += 3
            addy = 3
          else
            raise
          end
        end

        x = 0
        y += addy
      end
    end

    map.flatten.count('#')
  end

  def self.part2
    @rules = nil
    part1(18)
  end
end

RSpec.describe "Day21" do
  it "does part 1" do
    expect(Day21.part1).to eq(184) # 2232
  end

  it "does part 2" do
    expect(Day21.part2).to eq(2810258)
  end
end
