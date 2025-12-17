class Day02 < Helper
  def self.part1
    code = file.split(/,/).map(&:to_i)
    code[1] = 12
    code[2] = 2

    Machine.new(code).compute[0]
  end

  def self.part2
    code_template = file.split(/,/).map(&:to_i)
    code_template.keys.combination(2) do |num1, num2|
      code = code_template.clone
      code[1] = num1
      code[2] = num2

      result = Machine.new(code).compute[0]
      return "#{num1}#{num2}".to_i if result == 19690720
    end
  end
end

RSpec.describe "Day02" do
  it "does part 1" do
    expect(Day02.part1).to eq(4484226)
  end

  it "does part 2" do
    expect(Day02.part2).to eq(5696)
  end
end
