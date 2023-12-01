class Day01 < Helper
  def self.part1
    file.split("\n").sum do |line|
      matches = line.scan(/\d/)

      "#{matches.first}#{matches.last}".to_i
    end
  end

  def self.part2
    posh = {
      'one'   => 1,
      'two'   => 2,
      'three' => 3,
      'four'  => 4,
      'five'  => 5,
      'six'   => 6,
      'seven' => 7,
      'eight' => 8,
      'nine'  => 9,
      '1'     => 1,
      '2'     => 2,
      '3'     => 3,
      '4'     => 4,
      '5'     => 5,
      '6'     => 6,
      '7'     => 7,
      '8'     => 8,
      '9'     => 9,
    }

    count = 0
    file.split("\n").each do |line|
      pos = posh.keys.map{|n| [n, line.index(n), line.rindex(n)] }.select{|p| !p[1].nil? }

      first = pos.min_by{|p| p[1] }
      last  = pos.max_by{|p| p[2] }

      num = "#{posh[first[0]]}#{posh[last[0]]}".to_i

      count += num
    end
    count
  end
end

RSpec.describe "Day01" do
  it "does part 1" do
    expect(Day01.part1).to eq(55090)
  end

  it "does part 2" do # 54819
    expect(Day01.part2).to eq(54845)
  end
end
