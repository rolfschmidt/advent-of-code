class Day16 < Helper
  def self.part1(list = nil)
    list ||=  begin
      start = []
      ('a'..'p').each do |char|
        start << char
      end
      start
    end

    file.split(",").each do |cmd|
      case cmd
      when /^s(\d+)$/
        range = $1.to_i
        list = list[-range..] + list[0..-(range + 1)]
      when /^x(\d+)\/(\d+)$/
        list[$1.to_i], list[$2.to_i] = list[$2.to_i], list[$1.to_i]
      when /^p([a-z]+)\/([a-z]+)$/
        ai = list.index($1)
        bi = list.index($2)
        list[ai], list[bi] = list[bi], list[ai]
      else
        raise
      end
    end

    list.join('')
  end

  def self.part2
    list = nil
    seen = []
    r = 0
    while r < 1000000000 do
      list = part1(list&.split(''))

      if seen.include?(list)
        r = 1000000000 - (1000000000 % r) 
      end

      seen << list
      r += 1
    end
    list
  end
end

RSpec.describe "Day16" do
  it "does part 1" do
    expect(Day16.part1).to eq('olgejankfhbmpidc')
  end

  it "does part 2" do
    expect(Day16.part2).to eq('gfabehpdojkcimnl')
  end
end