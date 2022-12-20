class Day20 < Helper
  def self.find_node(links, data)
    links.reverse_each_node.detect{|n| n.data == data }
  end

  def self.part1(part2 = false)
    nums_init = file.split("\n").map(&:to_i)
    if part2
      nums_init = nums_init.map{|v| v * 811589153 }
    end

    nums = nums_init.map.with_index {|v, i| { v: v, i: i } }
    (part2 ? 10 : 1).times do |rr|
      nums_init.each_with_index do |num_init, i|
        if num_init != 0
          nums.each_with_index do |num, j|
            next if num[:i] != i

            ti = j
            tr = num[:v].positive? ? 1 : -1
            (num[:v].abs).times do
              ti += tr
              if ti == nums.count
                ti = 1
              elsif ti < 0
                ti = nums.count - 2
              end
            end

            nums.insert(ti, nums.delete_at(j))

            break
          end
        end
      end
    end

    result = nums.map{|v| v[:v] }
    zero   = result.index(0)

    [1000, 2000, 3000].map do |n|
      result[(n + zero) % result.count]
    end.sum
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day20" do
  it "does part 1" do
    expect(Day20.part1).to eq(11123)
  end

  # it "does part 2" do
  #   expect(Day20.part2).to eq(100)
  # end
end