class Day24 < Helper
  def self.part1(part2 = false)
    list = file.split("\n").map{|r| r.split("/").map(&:to_i) }

    max = 0
    len = 0
    list.each_with_index do |sr, sri|
      next if sr.exclude?(0)

      next_port = sr.detect{|p| p != 0 }

      queue = [
        [ next_port, [sri] ]
      ]
      while queue.present?
        find_port, used_rows = queue.shift

        list.each_with_index do |r, ri|
          next if used_rows.include?(ri)
          next if r.exclude?(find_port)
          next if r.include?(0)

          next_port = r.detect{|p| p != find_port } || find_port

          queue << [next_port, used_rows + [ri] ]
        end

        if part2
          used_sum = used_rows.map{|i| list[i] }.flatten.sum
          if used_rows.size > len
            len = used_rows.size
            max = used_sum
          elsif used_rows.size == len && used_sum > max
            len = used_rows.size
            max = used_sum
          end
        else
          max = [max, used_rows.map{|i| list[i] }.flatten.sum].max
        end
      end
    end

    max
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day24" do
  it "does part 1" do
    expect(Day24.part1).to eq(1868) # 1854 1861
  end

  it "does part 2" do
    expect(Day24.part2).to eq(1841)
  end
end