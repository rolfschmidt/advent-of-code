class Day08 < Helper
  def self.image_layer_get(data, width, height)
    data = data.chomp.chars
    result = []

    while data.any?
      layer = []

      height.times do
        layer_part = []
        width.times do
          value = data.shift
          return result if value.nil?
          layer_part << value.to_i
        end
        layer << layer_part
      end

      result << layer
    end

    result
  end

  def self.lowest_zero_layer_get(data)
    result = nil
    lowest_layer_zeros = nil

    Array.wrap(data).each do |layer|
      layer_zeros = 0

      Array.wrap(layer).each do |part|
        Array.wrap(part).each do |number|
          next unless number == 0
          layer_zeros += 1
        end
      end

      next if !lowest_layer_zeros.nil? && lowest_layer_zeros < layer_zeros

      lowest_layer_zeros = layer_zeros
      result = layer
    end

    result
  end

  def self.layer_multiply(layer)
    number1_count = 0
    number2_count = 0

    Array.wrap(layer).each do |part|
      number1_count += part.count { |v| v == 1 }
      number2_count += part.count { |v| v == 2 }
    end

    number1_count * number2_count
  end

  def self.image_data_get(data)
    image = {}

    (0...data.size).each do |layer_index|
      (0...data[layer_index].size).each do |part_index|
        (0...data[layer_index][part_index].size).each do |number_index|
          value = data[layer_index][part_index][number_index]

          image[part_index] ||= {}
          image[part_index][number_index] ||= 2

          if image[part_index][number_index] == 2 && (value == 1 || value == 0)
            image[part_index][number_index] = value
          end
        end
      end
    end

    image
  end

  def self.image_string_get(data)
    result = ""

    data.keys.sort.each do |y|
      data[y].keys.sort.each do |x|
        result << (data[y][x] == 1 ? "1" : ".")
      end
      result << "\n"
    end

    result
  end

  def self.part1
    result = image_layer_get(file, 25, 6)
    layer = lowest_zero_layer_get(result)
    layer_multiply(layer)
  end

  def self.part2
    result = image_layer_get(file, 25, 6)
    image_part2 = image_data_get(result)
    return "\n" + image_string_get(image_part2)
  end
end

RSpec.describe "Day08" do
  it "does part 1" do
    expect(Day08.part1).to eq(1206)
  end

  it "does part 2" do
    # EJRGP
    expect(Day08.part2).to eq('
1111...11.111...11..111..
1.......1.1..1.1..1.1..1.
111.....1.1..1.1....1..1.
1.......1.111..1.11.111..
1....1..1.1.1..1..1.1....
1111..11..1..1..111.1....
')
  end
end
