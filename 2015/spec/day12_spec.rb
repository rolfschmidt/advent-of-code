class Day12 < Helper
  def self.parse(json, part2 = false)
    return json if json.is_a?(Integer)
    return json.to_i if json.is_a?(String) && json.is_number?
    return if json.is_a?(String)

    result = []
    if json.is_a?(Array)
      json.each{|v| result <<  parse(v, part2) }
    elsif json.is_a?(Hash)
      if !part2 || (part2 && json.values.exclude?('red') && json.keys.exclude?('red'))
        json.each do |k, v|
          result << parse(k, part2)
          result << parse(v, part2)
        end
      end
    else
      raise
    end
    result
  end

  def self.part1(part2 = false)
    data = JSON.parse(file.chomp)
    parse(data, part2).flatten.compact.sum
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day12" do
  it "does part 1" do
    expect(Day12.part1).to eq(191164)
  end

  it "does part 2" do
    expect(Day12.part2).to eq(87842)
  end
end
