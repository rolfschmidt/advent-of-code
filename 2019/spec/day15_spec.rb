class Day15 < Helper
  def self.dir_map
    @dir_map ||= {
      1 => DIR_UP,
      2 => DIR_DOWN,
      3 => DIR_LEFT,
      4 => DIR_RIGHT,
    }
  end

  def self.search(pos, machine)
    @seen ||= Set.new
    @total_steps ||= INT_MAX
    return if @seen.include?(pos)
    @seen << pos

    (1..4).each do |dir|
      steps = machine.input.size + 1
      break if steps >= @total_steps


      new_machine = ddup(machine)
      new_machine.input << dir
      new_machine.compute
      answer = new_machine.output[-1]
      if answer == 2
        @total_steps = [@total_steps, machine.input.size + 1].min
        next
      end

      next if answer != 1

      search(pos + dir_map[dir], new_machine)
    end
  end

  def self.part1
    search(Vector.new(0, 0), Machine.new(file, input: [], all: true))

    @total_steps
  end

  def self.part2
    queue      = []
    total      = 0
    seen       = Set.new
    next_queue = [[Vector.new(0, 0), Machine.new(file, input: [], all: true)]]
    while_stable do
      next_queue, queue = queue, next_queue

      while queue.present?
        pos, machine = queue.shift
        next if seen.include?(pos)
        seen << pos

        (1..4).each do |dir|
          new_machine = ddup(machine)
          new_machine.input << dir
          new_machine.compute
          answer = new_machine.output[-1]
          next if [1, 2].exclude?(answer)

          next_queue << [pos + dir_map[dir], new_machine]
        end
      end

      total += 1
      stable if next_queue.present?
    end

    total
  end
end

RSpec.describe "Day15" do
  it "does part 1" do
    expect(Day15.part1).to eq(218)
  end

  it "does part 2" do
    expect(Day15.part2).to eq(544)
  end
end
