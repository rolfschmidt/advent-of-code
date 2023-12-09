class Day04 < Helper
  def self.part1
    key = file.chomp
    (0..1000000).find do |i|
      Digest::MD5.hexdigest("#{key}#{i}").starts_with?('00000')
    end
  end

  def self.part2
    key = file.chomp
    (1000000..10000000).find do |i|
      Digest::MD5.hexdigest("#{key}#{i}").starts_with?('000000')
    end
  end
end

RSpec.describe "Day04" do
  it "does part 1" do
    expect(Day04.part1).to eq(282749)
  end

  it "does part 2" do
    expect(Day04.part2).to eq(9962624)
  end
end
