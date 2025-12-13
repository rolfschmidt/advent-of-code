class Day12 < Helper
  def self.shapes_size(shapes, shape_counts)
    shape_counts.keys.map { shapes[_1][0].size * shape_counts[_1] }.sum
  end

  def self.shapes_fit?(map, shapes, shape_counts, history = [])
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

            shapes_fit?(new_map, shapes, new_shape_counts, history + [shape])
          end
        end
      end
    end
  end

  def self.part1
    blocks  = file.blocks
    regions = blocks.pop.lines.map(&:numbers)
    shapes  = blocks.map do
      lines = _1.lines
      lines.shift
      lines.to_lines
    end
    regions.keys.each do |bi|
      region = regions[bi]
      x = region.shift
      y = region.shift

      regions[bi].unshift(Map.init_map(x - 1, y - 1, '.').select_value('.').keys.to_set)
    end

    shape_variants = shapes.map do |shape|
      shape.to_2d.all_variants.map { _1.to_map.select_value('#').keys.to_set }
    end

    Parallel.map(regions) do |region|
      shapes_fit?(region[0], shape_variants, region[1..]) ? 1: 0
    end.sum
  end

  def self.part2
    part1
  end
end

RSpec.describe "Day12" do
  it "does part 1" do
    expect(Day12.part1).to eq(544)
  end
end
