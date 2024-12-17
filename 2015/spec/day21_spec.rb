class Day21 < Helper
  def self.shop_string
    "Weapons:    Cost  Damage  Armor
Dagger        8     4       0
Shortsword   10     5       0
Warhammer    25     6       0
Longsword    40     7       0
Greataxe     74     8       0

Armor:      Cost  Damage  Armor
Leather      13     0       1
Chainmail    31     0       2
Splintmail   53     0       3
Bandedmail   75     0       4
Platemail   102     0       5

Rings:      Cost  Damage  Armor
Damage one    25     1       0
Damage two   50     2       0
Damage three   100     3       0
Defense one   20     0       1
Defense two   40     0       2
Defense three   80     0       3"
  end

  def self.cost(row)
    row[1].map { _1[0] }.sum
  end

  def self.player_dead?(row)
    row[0] < 1
  end

  def self.enemy_dead?(row)
    row[2][0] < 1
  end

  def self.damage(row)
    if row[1].is_a?(Array)
      row[1].map { _1[1] }.sum
    else
      row[1]
    end
  end

  def self.defense(row)
    if row[1].is_a?(Array)
      row[1].map { _1[2] }.sum
    else
      row[2]
    end
  end

  def self.part1(part2 = false)
    weapons, armor, rings = shop_string.blocks.map(&:numbers).map{ _1.each_slice(3).to_a }

    enemy = file.numbers
    queue = []

    weapons.each do |iw|
      queue << [100, [iw.clone], enemy.clone]

      armor.each do |ia|
        queue << [100, [iw.clone, ia.clone], enemy.clone]

        rings.combination(1).each do |irs|
          queue << [100, [iw.clone, ia.clone] + irs, enemy.clone]
        end
        rings.combination(2).each do |irs|
          queue << [100, [iw.clone, ia.clone] + irs, enemy.clone]
        end
      end

      rings.combination(1).each do |irs|
        queue << [100, [iw.clone] + irs, enemy.clone]
      end
      rings.combination(2).each do |irs|
        queue << [100, [iw.clone] + irs, enemy.clone]
      end
    end

    min_cost = 99999999999999
    max_cost = 0
    while queue.present?
      fight          = queue.pop
      player_damage  = damage(fight)
      player_defense = defense(fight)
      enemy_damage   = damage(fight[2])
      enemy_defense  = defense(fight[2])
      cost           = cost(fight)

      fight[2][0] -= [1, player_damage - enemy_defense].max

      if enemy_dead?(fight)
        min_cost = cost if cost < min_cost
        next
      end

      fight[0] -= [1, enemy_damage - player_defense].max

      if player_dead?(fight)
        max_cost = cost if cost > max_cost
        next
      end

      queue << fight
    end

    return max_cost if part2

    min_cost
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day21" do
  it "does part 1" do
    expect(Day21.part1).to eq(91) # 25 103 111
  end

  it "does part 2" do
    expect(Day21.part2).to eq(158) # 356
  end
end