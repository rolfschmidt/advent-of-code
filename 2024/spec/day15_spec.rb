class Day15 < Helper
  def self.part1(part2 = false)
    map, moves = file.blocks
    moves = moves.lines.join.chars
    map = map.to_map

    start = map.select_value('@').keys.first
    pos = start
    moves.each do |move|
      dir   = DIRS_STRING[move]
      next_pos = pos + dir
      next if map[next_pos] == '#'

      if map[next_pos] == '.'
        map[pos] = '.'
        map[next_pos] = '@'
      elsif map[next_pos] == 'O'
        found = false
        sub_pos = next_pos
        while true do
          sub_pos = sub_pos + dir
          break if map[sub_pos] == '#'

          if map[sub_pos] == '.'
            map[sub_pos] = 'O'
            found = true
            break
          end
        end

        next if !found

        map[pos] = '.'
        map[next_pos] = '@'
      end

      pos = next_pos
    end

    map.select_value('O').keys.map{ _1[0] + _1[1] * 100 }.sum
  end

  def self.part2
    map, moves = file.blocks
    moves = moves.lines.join.chars

    map = map.gsub('#', '##').gsub('O', '[]').gsub('.', '..').gsub('@', '@.')
    map = map.to_map

    start = map.select_value('@').keys.first
    pos = start
    moves.each do |move|
      dir   = DIRS_STRING[move]
      next_pos = pos + dir
      next if map[next_pos] == '#'

      if map[next_pos] == '.'
        map[pos] = '.'
        map[next_pos] = '@'
      elsif ['[', ']'].include?(map[next_pos])
        next_posses = []
        if map[next_pos] == '['
          next_posses = [next_pos, next_pos + right]
        else
          next_posses = [next_pos + left, next_pos]
        end

        found = false
        if [DIR_UP, DIR_DOWN].include?(dir)
          connected = Set.new
          queue     = next_posses.clone
          seen      = Set.new
          while queue.present?
            check_pos = queue.shift
            connected << check_pos

            next if seen.include?(check_pos)
            seen << check_pos

            map.steps(check_pos, dir).each do |step_pos|
              next if ['[', ']'].exclude?(map[step_pos])

              queue << step_pos
              if map[step_pos] != map[step_pos + DIRS_OPPOSITE[dir]]
                queue << (map[step_pos] == '[' ? step_pos + right : step_pos + left)
              end
            end
          end

          next if connected.select { connected.exclude?(_1 + dir) }.any? { map[_1 + dir] != '.' }

          new_map = map.clone
          connected = connected.sort_by { _1.y }
          connected.reverse! if dir == DIR_DOWN

          connected.each do |check_pos|
            new_map[check_pos + dir] = map[check_pos]
            new_map[check_pos] = '.'
          end

          map = new_map
          found = true
        else
          new_map = map.clone
          found     = false
          start_pos = dir == DIR_LEFT ? next_posses[0] : next_posses[1]
          sub_pos   = start_pos
          while true do
            sub_pos = sub_pos + dir
            break if map[sub_pos] == '#'

            if map[sub_pos] == '.'
              from_x = [start_pos.x, sub_pos.x].min
              to_x = [start_pos.x, sub_pos.x].max

              if dir == DIR_LEFT
                from_x.upto(to_x).each do |check_x|
                  check_pos = Vector.new(check_x, sub_pos.y)
                  map[check_pos] = map[check_pos + right]
                end
              else
                to_x.downto(from_x).each do |check_x|
                  check_pos = Vector.new(check_x, sub_pos.y)
                  map[check_pos] = map[check_pos + left]
                end
              end

              found = true
              break
            end
          end
        end

        next if !found

        map[pos] = '.'
        map[next_pos] = '@'
      end

      pos = next_pos
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