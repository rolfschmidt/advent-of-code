class Day04 < Helper
  def self.part1(part2 = false)
    passwords = file.split("\n").count do |pw|
      ps = pw.split(" ")
      
      ps.count == ps.uniq.count
    end
  end

  def self.part2
    passwords = file.split("\n").count do |pw|
      ps = pw.split(' ').map{|p| p.split('') }

      valid = true
      ps.each_with_index do |pa, pai|
        ps.each_with_index do |pb, pbi|
          next if pai == pbi
          next if pa.sort != pb.sort
          valid = false
        end
      end
      
      valid
    end
  end
end

RSpec.describe "Day04" do
  it "does part 1" do
    expect(Day04.part1).to eq(386)
  end

  it "does part 2" do
    expect(Day04.part2).to eq(208)
  end
end