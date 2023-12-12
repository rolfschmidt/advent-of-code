class Day12 < Helper
  def self.search(list, numbers, seen = [])
    targets    = list.chars.keys.select{|i| list[i] == '?' }
    # regex_goal = numbers.map{|n| "\#{#{n}}" }.join("([^#]+)")
    result     = 0

    combos = targets.combination(numbers.sum - list.count('#'))
    count = 0
    combos.each do |combo|
      count += 1
      if count % 100000 == 0
        puts count
      end

      new_list = list.clone
      combo.each do |ti|
        new_list[ti] = '#'
      end
      new_list.gsub!('?', '.')

      # new_list = '...####.##..#####.'
      new_list += '.'

      valid = true
      ni    = 0
      pack  = ''
      new_list.chars.each_with_index do |c, ci|
        if c == '#'
          pack += c
        elsif pack != '' && c == '.'
          if pack.length == numbers[ni]

            ni += 1
            pack        = ''
            break if numbers[ni].nil?
            next
          else
            valid = false
            break
          end
        end
      end

      # pp [new_list, numbers, valid]
      # exit

      next if !valid

      # next if new_list.match(/#{regex_goal}/).blank?

      result += 1
    end

    result
  end

  def self.search_bfs(target_string, numbers)
    target_string = ".#{target_string}."
    empty_char    = ['.', '?']
    raute_char    = ['#', '?']
    queue         = [ [target_string, 0, 0, [0, target_string]] ]
    total         = 0

    # pp numbers
    seen = {}
    counter = 0
    save = 0
    while queue.present?
      check_string, start_pos, number_index = queue.shift

      counter += 1
      if counter % 1000000 == 0
        puts "#{counter} - #{queue.count}"
      end

      # if number_index > numbers.size - 1
      #   next if check_string.split(/\#+/).count > numbers.size + 1
      #   # pp [start_pos, number_index, history]
      #   seen[check_string.gsub('?', '.')] = true
      #   next
      # end

      number_range = numbers[number_index]

      (start_pos..target_string.size - 1).each do |vi|
        v = target_string[vi]

        peek_string = check_string[vi..vi+number_range-1].gsub('?', '#')
        if raute_char.include?(check_string[vi]) && empty_char.include?(check_string[vi - 1]) && empty_char.include?(check_string[vi + number_range]) && peek_string == '#' * number_range
          # puts "---"
          # pp ['index', check_string[vi..], number_range ]
          # pp ['char', check_string[vi] ]
          # pp ['off', check_string[vi + number_range] ]
          # pp ['peek', peek_string ]

          queue_string                        = check_string.clone
          queue_string[vi..vi + number_range - 1] = '#' * number_range
          queue_string[vi + number_range]     = '.'

          # pp ['queue', queue_string]
          if number_index == numbers.size - 1
            next if queue_string.split(/\#+/).count > numbers.size + 1
            seen[queue_string.gsub('?', '.')] = true
          else
            next if queue_string.size - vi < numbers[number_index..].sum + numbers[number_index..].count
            # next if queue_string[vi + number_range..].index('#').blank? && queue_string[vi + number_range..].index('?').blank?
            # rest = queue_string[vi + number_range..]
            # next if rest.count('#') + rest.count('?') < numbers[number_index + 1..].sum
            # regex = numbers[number_index..].map{|n| "(\\#|\\?){#{n}}[^\#]+" }.join('')
            # # pp regex
            # if !queue_string[vi..].match(regex)
            #   save += 1
            #   next
            # end


            queue << [queue_string, vi + number_range, number_index + 1]
          end
        end
      end
    end

    # puts save if save > 0

    # pp target_string
    # pp numbers
    # pp seen

    seen.keys.count
  end

  def self.part1(part2 = false)
    list       = "..??..??...?##.."
    list       = ".???.###."
    list       = ".?###????????."
    numbers    = [1,1,3]
    numbers    = [3,2,1]
    # regex_goal = numbers.map{|n| "\#{#{n}}" }.join("([^#]+)")
    # count      = 0
    # while list.count('?') > 0
    #   list1 = list.sub('?', '#')
    #   list2 = list.sub('?', '.')
    #   count += 1 if list1.match(regex_goal)
    #   count += 1 if list2.match(regex_goal)

    #   list.sub!('?', '.')
    # end

    list = "?#???#.??????##?#?"
    numbers = [4, 1, 1, 6]

    # pp list
    # pp search(list, numbers)

    # pp search_bfs(list, numbers)

    # result = list.scan(/(\.|\?)+(\#|\?){3}(\.|\?)+/)
    # pp result
    # pp result.count

    # exit

    # results = Parallel.map([1,2,3,4]) do |combo|
    #   [combo]
    # end.reduce()

    # pp results
    # exit





    arrangements = file.split("\n").map{|line| line.split(" ") }.map do |arrangement, numbers|
      [arrangement, numbers.numbers]
    end

    # arrangements.sum do |arrangement, numbers|
    Parallel.map(arrangements) do |arrangement, numbers|
      if part2
        ac = arrangement.clone
        nc = numbers.clone

        4.times { arrangement += '?' + ac }
        4.times { numbers += nc }
      end

      pp [arrangement[0..5], arrangement.length, numbers.length]

      # a = search(arrangement, numbers)
      # b = search_bfs(arrangement, numbers)
      # if a != b
      #   pp [arrangement, numbers]
      # end

      # a
      r = search_bfs(arrangement, numbers)
      puts r
      r
    end.sum
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day12" do
  it "does part 1" do
    expect(Day12.part1).to eq(7792)
  end

  it "does part 2" do
    expect(Day12.part2).to eq(100)
  end
end
