class Day10 < Helper
  def self.part1(part2 = false, base_string = file)
    lengths = base_string.split(",").map(&:to_i)
    size = 256
    list = (0..size - 1).to_a
    skip = 0
    rounds = 1
      
    if part2
      lengths = base_string.split('').map(&:ord)
      lengths += [17, 31, 73, 47, 23]
      rounds = 64
    end

    i = 0
    rounds.times do
      lengths.each do |len|
        rlist = []
        ri = i
        len.times do
          rlist << list[ri]
          ri = (ri + 1) % list.size
        end
        rlist = rlist.reverse
        
        ri = i
        len.times do
          list[ri] = rlist.shift
          ri = (ri + 1) % list.size
        end

        i = (i + len + skip) % list.size
        skip += 1
      end
    end

    if part2
      return list.each_slice(16).map{|s| s.reduce(:^) }.map{|v| v.to_s(16).rjust(2, '0') }.join('')
    end

    list[0] * list[1]
  end

  def self.part2
    part1(true)
  end
end