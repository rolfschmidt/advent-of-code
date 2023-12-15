class Day15 < Helper
  def self.part1(check = nil)
    check = file.chomp.split(",") if !check

    check.each_with_object([]) do |data, result|
      pos_value = 0
      data.chars.each do |value|
        pos_value += value.ord
        pos_value *= 17
        pos_value %= 256
      end
      result << pos_value
    end.sum
  end

  def self.part2
    boxes = [nil] * 255
    file.chomp.split(",").each do |data|
      box      = [data.words[0], data.numbers[0]]
      location = part1([data.words[0]])

      boxes[location] ||= []
      if data.include?('-')
        boxes[location] = boxes[location].select{|b| b[0] != box[0] }
      elsif boxes[location].find{|b| b[0] == box[0] }
        boxes[location] = boxes[location].map{|b| b[0] == box[0] ? box : b }
      else
        boxes[location] << box
      end
    end

    total = 0
    boxes.each_with_index do |b, bi|
      next if b.blank?
      b.each_with_index do |r, ri|
        total += (bi + 1) * (ri + 1) * r[1]
      end
    end
    total
  end
end

RSpec.describe "Day15" do
  it "does part 1" do
    expect(Day15.part1).to eq(512283)
  end

  it "does part 2" do
    expect(Day15.part2).to eq(215827)
  end
end
