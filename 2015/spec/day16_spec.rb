class Day16 < Helper
  def self.search
    @search ||= {
      children: 3,
      cats: 7,
      samoyeds: 2,
      pomeranians: 3,
      akitas: 0,
      vizslas: 0,
      goldfish: 5,
      trees: 3,
      cars: 2,
      perfumes: 1,
    }
  end

  def self.sues
    @sues ||= file.split("\n").map do |line|
      line.words.select{|v| !v.is_number? }.zip(line.numbers).to_h.symbolize_keys
    end
  end

  def self.part1
    sues.find do |s|
      search.all? do |k, v|
        !s.key?(k) || s[k] == v
      end
    end[:Sue]
  end

  def self.part2
    sues.find do |s|
      search.all? do |k, v|
        !s.key?(k) ||
        ([:cats, :trees].include?(k) && s[k] > v) ||
        ([:pomeranians, :goldfish].include?(k) && s[k] < v) ||
        s[k] == v
      end
    end[:Sue]
  end
end

RSpec.describe "Day16" do
  it "does part 1" do
    expect(Day16.part1).to eq(373)
  end

  it "does part 2" do
    expect(Day16.part2).to eq(260)
  end
end