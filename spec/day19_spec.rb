Robot = Struct.new(:cost_ore, :cost_clay, :cost_obsidian, :cost_geode, :round_ore, :round_clay, :round_obsidian, :round_geode) do
  def affordable?(bp)
    return if bp.total_ore < cost_ore
    return if bp.total_clay < cost_clay
    return if bp.total_obsidian < cost_obsidian
    return if bp.total_geode < cost_geode

    true
  end

  def income
    @income ||= [round_ore, round_clay, round_obsidian, round_geode]
  end

  def price
    @price ||= [
      -cost_ore,
      -cost_clay,
      -cost_obsidian,
      -cost_geode,
    ]
  end
end

Blueprint = Struct.new(:id, :input_ore, :input_clay, :input_obsidian_1, :input_obsidian_2, :input_geode_1, :input_geode_2, :input_round) do
  attr_accessor :round
  attr_accessor :total_ore
  attr_accessor :total_clay
  attr_accessor :total_obsidian
  attr_accessor :total_geode
  attr_accessor :round_ore
  attr_accessor :round_clay
  attr_accessor :round_obsidian
  attr_accessor :round_geode

  def initialize(*)
    super
    @round          = self.input_round
    @total_ore      = 0
    @total_clay     = 0
    @total_obsidian = 0
    @total_geode    = 0
    @round_ore      = 1
    @round_clay     = 0
    @round_obsidian = 0
    @round_geode    = 0
  end

  def update_income(data)
    @round_ore      += data[0]
    @round_clay     += data[1]
    @round_obsidian += data[2]
    @round_geode    += data[3]
  end

  def produce
    [round_ore, round_clay, round_obsidian, round_geode]
  end

  def update(produce)
    @total_ore       += produce[0]
    @total_clay      += produce[1]
    @total_obsidian  += produce[2]
    @total_geode     += produce[3]
  end

  def robot_prices
    @robot_prices ||= [
      # ore, clay, obsidian, geode
      Robot.new(
        input_ore, 0, 0, 0,
        1, 0, 0, 0,
      ),
      Robot.new(
        input_clay, 0, 0, 0,
        0, 1, 0, 0,
      ),
      Robot.new(
        input_obsidian_1, input_obsidian_2, 0, 0,
        0, 0, 1, 0,
      ),
      Robot.new(
        input_geode_1, 0, input_geode_2, 0,
        0, 0, 0, 1,
      ),
    ]
  end

  def cache_key(round)
    result = [
      id,
      round,
      total_ore,
      total_clay,
      total_obsidian,
      total_geode,
      round_ore,
      round_clay,
      round_obsidian,
      round_geode,
    ]
  end
end

class Day19 < Helper
  def self.dfs(bp)
    if bp.round == 1
      produce = bp.produce
      bp.update(produce)

      new_best = bp.total_geode
      if @best < new_best
        @best = new_best
        puts "BP #{bp.id} | new best #{@best}"
      end

      return new_best
    end

    cache_key = bp.cache_key(bp.round)
    return @cache[cache_key] if @cache[cache_key]

    produce = bp.produce

    max_vals = 0
    bp.robot_prices.each do |robot|
      next if robot.round_ore == 1 && bp.round_ore > bp.input_ore && bp.round_ore > bp.input_clay && bp.round_ore > bp.input_obsidian_1 && bp.round_ore > bp.input_geode_1
      next if robot.round_clay == 1 && bp.round_clay > bp.input_obsidian_2
      next if robot.round_obsidian == 1 && bp.round_obsidian > bp.input_geode_2
      next if !robot.affordable?(bp)

      new_bp = bp.clone
      new_bp.update(robot.price)
      new_bp.update(produce)
      new_bp.update_income(robot.income)
      new_bp.round -= 1

      check_bp = dfs(new_bp)
      max_vals = [max_vals, check_bp].max
    end

    new_bp = bp.clone
    new_bp.update(produce)
    new_bp.round -= 1

    check_bp = dfs(new_bp)
    max_vals = [max_vals, check_bp].max

    @cache[cache_key] = max_vals

    return max_vals
  end

  def self.parse(part2 = false)
    bps    = []
    @cache = {}
    @best  = 0
    file.split("\n").each do |line|
      split = line.scan(/\d+/).map(&:to_i)
      bps << Blueprint.new(*split, (part2 ? 32 : 24))
    end
    bps
  end

  def self.part1
    bps = parse
    result = Parallel.map(bps, in_processes: 8) do |bp|
      dfs(bp) * bp.id
    end

    result.sum
  end

  def self.part2
    bps = parse(true).first(3)
    result = Parallel.map(bps, in_processes: 8) do |bp|
      dfs(bp)
    end

    result.inject(:*)
  end
end

RSpec.describe "Day19" do
  it "does part 1" do
    expect(Day19.part1).to eq(1624)
  end

  it "does part 2" do
    expect(Day19.part2).to eq(100)
  end
end