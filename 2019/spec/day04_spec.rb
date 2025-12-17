class Day04 < Helper
  def self.pass(input)
    splitrange = input.split('-')

    from   = splitrange[0].to_i
    to     = splitrange[1].to_i
    result = 0
    (from..to).each do |number|
      splitnumber = number.to_s.split('')

      increasing            = 1
      adjacentdigitslist    = {}
      adjacentdigitslistelf = {}
      adjacentdigits        = 0
      prevchar              = -1
      splitnumber.each do |char|
        char = char.to_i
        adjacentdigitslist[char] ||= 0
        adjacentdigitslist[char] += 1
        if adjacentdigitslist[char] > 1
            adjacentdigits = 1
        end

        if prevchar == char
          adjacentdigitslistelf[char] ||= 1
          adjacentdigitslistelf[char] += 1
        end

        if prevchar <= char
          prevchar = char
          next
        end

        increasing = 0

        break
      end

      next if increasing == 0

      if part2?
        adjacentdigits = 0
        adjacentdigitslistelf.values.each do |value|
          next if value != 2

          adjacentdigits = 1

          break
        end
      end

      next if adjacentdigits == 0

      result += 1
    end

    return result
  end

  def self.part1
    pass(file)
  end

  def self.part2
    part1
  end
end

RSpec.describe "Day04" do
  it "does part 1" do
    expect(Day04.part1).to eq(1748)
  end

  it "does part 2" do
    expect(Day04.part2).to eq(1180)
  end
end
