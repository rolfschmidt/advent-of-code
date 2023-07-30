class Day08 < Helper
  def self.part1(part2 = false)
    code = ''
    file.split("\n").each do |line|
      rline = line.split(" ")

      rline[0] = "mem['#{rline[0]}'] ||= 0; mem['#{rline[4]}'] ||= 0; mem['#{rline[0]}']"
      rline[1] = if rline[1] == 'inc'
        '+='
      else 
        '-='
      end
      
      rline[4] = "mem['#{rline[4]}']"
      
      code += "#{rline.join(' ')}\n"
      if part2
        code += "mem['max'] = mem.values.max\n"
      end
    end

    mem = { max: 0 }
    eval(code)

    mem.values.max
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day08" do
  it "does part 1" do
    expect(Day08.part1).to eq(6012)
  end

  it "does part 2" do
    expect(Day08.part2).to eq(6369)
  end
end