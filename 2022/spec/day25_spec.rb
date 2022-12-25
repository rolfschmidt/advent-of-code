class Day25 < Helper
  def self.snafu2dec(number)
    map = {
      "2" => 2,
      "1" => 1,
      "0" => 0,
      "-" => -1,
      "=" => -2,
    }

    number.chars.reverse.map.with_index do |n, i|
      (5 ** i) * map[n]
    end.sum
  end

  def self.dec2snafu(number)
    map = {
      0 => "0",
      1 => "1",
      2 => "2",
      3 => "=",
      4 => "-",
    }

    result = ""
    while number > 0 do
      rest   = number % 5
      number = number / 5

      result = map[rest] + result
      if rest > 2
        number += 1
      end
    end

    return result
  end

  def self.part1
    numbers = file.split("\n").map{|v| snafu2dec(v) }

    return dec2snafu(numbers.sum)
  end
end

RSpec.describe "Day25" do
  it "does part 1" do
    expect(Day25.part1).to eq("121=2=1==0=10=2-20=2")
  end
end