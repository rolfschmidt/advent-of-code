class Day11 < Helper
  @all_chars = ('a'..'z').to_a

  def self.part1(part2 = false)
    pw = file.chomp
    pw = @first if part2

    bi = pw.size - 1
    loop do
      ti     = @all_chars.index(pw[bi]) + 1
      pw[bi] = @all_chars[ti % @all_chars.size]

      if ti > 25
        bi -= 1
        next
      end

      rule_1 = @all_chars.each_cons(3).any?{|v| pw.include?(v.join('')) }
      rule_2 = ['i', 'o', 'l'].none?{|c| pw.include?(c) }
      rule_3 = pw.match(/(\w)\1.*(\w)\2/).present?
      break if rule_1 && rule_2 && rule_3

      bi = pw.size - 1
    end

    @first = pw
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day11" do
  it "does part 1" do
    expect(Day11.part1).to eq('vzbxxyzz')
  end

  it "does part 2" do
    expect(Day11.part2).to eq('vzcaabcc')
  end
end
