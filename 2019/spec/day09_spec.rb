class Day09 < Helper
  def self.part1
    Machine.new(file).compute
  end

  def self.part2
    Machine.new(file, input: 2).compute
  end
end

RSpec.describe "Day09" do
  it 'does day 9 - examples' do
    expect(Machine.new('1102,34915192,34915192,7,4,7,99,0').compute).to eq(1219070632396864)
    expect(Machine.new('104,1125899906842624,99').compute).to eq(1125899906842624)
    expect(Machine.new('109,2000,109,19,99', all: true).compute[:relative_base]).to eq(2019)
  end

  it "does part 1" do
    expect(Day09.part1).to eq(3013554615) # 1091204 2030
  end

  it "does part 2" do
    expect(Day09.part2).to eq(50158)
  end
end
