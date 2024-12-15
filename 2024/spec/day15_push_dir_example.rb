class Day15 < Helper
  def self.part1(part2 = false)
    map, moves = file.blocks
    moves      = moves.split(/\n/).join.chars
    map        = map.to_map

    pos = map.select_value('@').keys.first
    moves.each_with_index do |move, mi|
      dir     = DIRS_STRING[move]
      new_map = map.push_dir(pos, dir, 'O')
      next if new_map.blank?

      map = new_map
      pos = pos + dir
    end

    map.select_value('O').keys.map{ _1[0] + _1[1] * 100 }.sum
  end

  def self.part2
    map, moves = file.blocks
    moves      = moves.split(/\n/).join.chars
    map        = map.gsub('#', '##').gsub('O', '[]').gsub('.', '..').gsub('@', '@.')
    map        = map.to_map
    pos        = map.select_value('@').keys.first
    moves.each_with_index do |move, mi|
      dir     = DIRS_STRING[move]
      new_map = map.push_dir(pos, dir, '[]')
      next if new_map.blank?

      map = new_map
      pos = pos + dir
    end

    map.select_value {|value| ['O', ']'].include?(value) }.keys.map{ _1[0] - 1 + _1[1] * 100 }.sum
  end
end

RSpec.describe "Day15" do
  it "does part 1" do
    expect(Day15.part1).to eq(1442192)
  end

  it "does part 2" do
    expect(Day15.part2).to eq(1448458) # 2221627 2451358 2895107 2876971 2897517
  end
end