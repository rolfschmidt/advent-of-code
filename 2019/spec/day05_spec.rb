class Day05 < Helper
  def self.part1
    Machine.new(file.split(/,/).map(&:to_i)).compute
  end

  def self.part2
    Machine.new(file.split(/,/).map(&:to_i)).compute(input: 5)
  end
end

RSpec.describe "Day05" do
  def run(code, input: nil)
    value = Machine.new(code.split(/,/).map(&:to_i)).compute(input: input)
    value = value.join(',') if value.is_a?(Array)
    value
  end

  # it 'does run the machine' do
  #   expect(run('1,0,0,0,99')).to eq('2,0,0,0,99') # 1 + 1 = 2
  #   expect(run('2,3,0,3,99')).to eq('2,3,0,6,99') # 3 * 2 = 6
  #   expect(run('2,4,4,5,99,0')).to eq('2,4,4,5,99,9801') # 99 * 99 = 9801
  #   expect(run('1,1,1,4,99,5,6,0,99')).to eq('30,1,1,4,2,5,6,0,99') # day 2 example
  #   expect(run('1002,4,3,4,33')).to eq('1002,4,3,4,99') # 3 * 33 = 99
  # end

  it "does part 1" do
    expect(Day05.part1).to eq(4601506)
  end

  it "does part 2" do
    expect(Day05.part2).to eq(5525561)
  end
end
