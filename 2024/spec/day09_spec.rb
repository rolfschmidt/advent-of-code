class Day09 < Helper
  def self.part1(part2 = false)
    on      = true
    counter = 0
    check   = ''
    file.chars.each_with_index do |value, vi|
      value = value.to_i
      value.times {|i| check += "B#{(on ? counter.to_s : '.')}B" }
      counter += 1 if on
      on = !on
    end

    counts = check.numbers.tally
    if part2
      check.numbers.reverse.uniq.each do |num|
        search  = 'B.B' * counts[num]
        replace = "B#{num}B" * counts[num]

        si = check.index(search)
        ri = check.rindex(replace)

        next if si.blank?
        next if ri.blank?
        next if si >= ri

        check = check.sub(replace, search)
        check = check.sub(search, replace)
      end

      result = 0
      check.scan(/[^B]+/).flatten.each_with_index do |value, vi|
        next if value == '.'
        result += value.to_i * vi
      end

      return result
    end

    check.numbers.reverse.uniq.each do |num|
      counts[num].times do
        search  = 'B.B'
        replace = "B#{num}B"

        si = check.index(search)
        ri = check.rindex(replace)

        next if si.blank?
        next if ri.blank?
        next if si >= ri

        check = check.sub(search, replace)
        check = check.rsub(replace, search)
      end
    end

    result = 0
    check.numbers.each_with_index do |value, vi|
      result += value.to_i * vi
    end

    return result
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day09" do
  it "does part 1" do
    expect(Day09.part1).to eq(6283170117911) # 89312749423 89312744865 89312744873 5547170081 5628137933
  end

  it "does part 2" do
    expect(Day09.part2).to eq(6307653242596) # 12858768099288 12859447930615 6307653502443
  end
end
