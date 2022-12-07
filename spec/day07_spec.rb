class Day07 < Helper

  def self.part1(part2 = false)
    cmds = file.split("$ ").reject(&:empty?).map(&:chomp)

    pwd    = []
    result = {}
    cmds.each do |cmd|
      if cmd.start_with?("cd")
        dir = cmd.split[1]
        if dir == '/'
          pwd = ['/']
        elsif dir == '..'
          pwd.pop
        else
          pwd << dir
        end
      elsif cmd.start_with?('ls')
        size      = cmd.scan(/\n(\d+)/).map{|x| x[0].to_i }.sum
        count_dir = pwd.clone

        while count_dir.present?
          result[count_dir.clone] ||= 0
          result[count_dir.clone] += size.to_i
          count_dir.pop
        end
      else
        raise
      end
    end

    deletable = []
    used      = 70000000 - result[["/"]]
    need      = 30000000 - used

    count = 0
    result.keys.each do |dir|
      total = result[dir]

      if 30000000 <= used + total
        deletable << [dir.join, total]
      end

      next if dir.count == 1
      next if total > 100000

      count += total
    end

    return deletable.map{|x| x[1] }.min if part2

    count
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day07" do
  it "does part 1" do
    expect(Day07.part1).to eq(1555642)
  end

  it "does part 2" do
    expect(Day07.part2).to eq(5974547)
  end
end