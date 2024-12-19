Attack = Struct.new(:id, :mana_cost, :damage, :heal_life, :heal_mana, :turns, :armor, :active) do
  def initialize(...)
    super
    self.damage ||= 0
    self.heal_life ||= 0
    self.heal_mana ||= 0
    self.armor ||= 0
    self.active ||= false
  end
end
Player = Struct.new(:name, :life, :damage, :items, :mana, :armor, :mana_spent) do
  def initialize(...)
    super
    self.life ||= 0
    self.damage ||= 0
    self.mana ||= 0
    self.armor ||= 0
    self.mana_spent ||= 0
    self.items ||= {}
  end

  def dps
    self.damage || 0
  end

  def defense
    if items['Shield']
      items['Shield'][:armor]
    else
      0
    end
  end

  def buffs(op)
    new_items = {}
    self.items.each do |id, item|
      next if item.turns.nil?

      item.turns -= 1

      self.life += item.heal_life
      self.mana += item.heal_mana

      op.life -= item.damage

      if item.turns && item.turns > 0
        new_items[item.id] = item
      end
    end

    self.items = new_items
  end

  def attack(op)
    if self.name != 'me'
      dmg = [1, dps - op.defense].max
      op.life -= dmg
    end

    items.map do |id, item|
      next if !item.turns.nil?

      op.life -= item.damage
      self.life += item.heal_life
      self.mana += item.heal_mana
    end
  end

  def dead?
    self.life < 1
  end
end

class Day22 < Helper
  def self.items
    @items ||= [
      Attack.new(id: 'Magic Missile', mana_cost: 53, damage: 4, active: true),
      Attack.new(id: 'Drain', mana_cost: 73, damage: 2, heal_life: 2, active: true),
      Attack.new(id: 'Shield', mana_cost: 113, armor: 7, turns: 6),
      Attack.new(id: 'Poison', mana_cost: 173, damage: 3, turns: 6),
      Attack.new(id: 'Recharge', mana_cost: 229, heal_mana: 101, turns: 5),
    ]
  end

  def self.part1(part2 = false)
    players = [
      Player.new(name: 'me', life: 50, mana: 500),
      Player.new('boss', *file.numbers),
    ]

    mana_per_damage = items.map do |item|
      next 100 if item.damage.zero?
      item.mana_cost / item.damage
    end.min

    min_spent = 999999999999999999

    queue = Heap.new {|a, b| a[1].life < b[1].life }
    queue << players + [1]
    seen = {}
    while queue.present? do
      p1, p2, round = queue.pop

      p1.buffs(p2)
      if p2.dead?
        min_spent = p1.mana_spent if p1.mana_spent < min_spent
        next
      end

      key = "#{p1.inspect}_#{p2.life}"
      next if seen[key]
      seen[key] = true

      if round % 2 == 0
        np1 = ddup(p1)
        np2 = ddup(p2)

        np2.attack(np1)
        next if np1.dead?

        queue << [np1, np2, round + 1]
      else
        p1.life -= 1 if part2

        items.each do |item|
          next if p1.mana < item.mana_cost
          next if p1.items[item.id]

          np1 = ddup(p1)
          np2 = ddup(p2)
          np1.items[item.id] = ddup(item)
          np1.mana -= item.mana_cost
          np1.mana_spent += item.mana_cost

          np1.attack(np2)

          if np2.dead?
            min_spent = np1.mana_spent if np1.mana_spent < min_spent
            next
          end

          queue << [np1, np2, round + 1]
        end
      end
    end

    min_spent
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day22" do
  it "does part 1" do
    expect(Day22.part1).to eq(1269) # 2343 2520
  end

  it "does part 2" do
    expect(Day22.part2).to eq(1309)
  end
end