class Day25 < Helper
  def self.part1
    input = file.split("\n\n")

    start = input[0].scan(/([A-Z])\./).first.first
    stop = input[0].scan(/\d+/).first.to_i

    states = {}
    input[1..].each do |inp_state|
      name = inp_state.scan(/state ([A-Z])/)[0][0]
      data = inp_state.scan(/.*\s(\w+)\./).flatten
      data[0] = data[0].to_i
      data[3] = data[3].to_i

      states[name] = data
    end

    list = {}
    pos = 0
    check = states[start]
    stop.times do 
      if list[pos] == 1
        list[pos] = check[3]
        pos += check[4] == 'left' ? -1 : 1
        check = states[check[5]]
      else
        list[pos] = check[0]
        pos += check[1] == 'left' ? -1 : 1
        check = states[check[2]]
      end
    end

    list.values.count(1)
  end

  def self.part2
    100
  end
end

RSpec.describe "Day25" do
  it "does part 1" do
    expect(Day25.part1).to eq(3362)
  end
end