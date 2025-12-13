class Day12 < Helper
  def self.shapes_size(shapes, shape_counts)
    shape_counts.keys.map { shapes[_1][0].size * shape_counts[_1] }.sum
  end

  def self.shapes_fit?(map, shapes, shape_counts)
    if shape_counts.all?(0)
      true
    elsif shapes_size(shapes, shape_counts) > map.size
      false
    else
      map.any? do |pos|
        shape_counts.each_with_index.any? do |shape_count, shape_index|
          next if shape_count.zero?

          shapes[shape_index].any? do |shape|
            next if shape.size > map.size
            next if shape.any? { !map.include?(pos + _1) }

            new_shape_counts = shape_counts.clone
            new_shape_counts[shape_index] -= 1

            new_map = map.clone
            new_map -= shape.map { pos + _1 }

            shapes_fit?(new_map, shapes, new_shape_counts)
          end
        end
      end
    end
  end

  def self.null_set(x, y)
    Map.init_map(x - 1, y - 1, '.').select_value('.').keys.to_set
  end

  def self.shape_list(string)
    string.to_2d.all_variants.map { _1.to_map.select_value('#').keys.to_set }
  end

  def self.part1
    blocks  = file.blocks
    regions = blocks.pop.lines.map(&:numbers).map { [null_set(_1[0], _1[1])] + _1[2..] }
    shapes  = blocks.map { _1.lines[1..].to_lines }.map { shape_list(_1).sort_by(&:size).reverse }

    Parallel.map(regions) do |region|
      shapes_fit?(region[0], shapes, region[1..]) ? 1: 0
    end.sum
  end
end

RSpec.describe "Day12" do
  it "does part 1" do
    expect(Day12.part1).to eq(544)
  end
end
