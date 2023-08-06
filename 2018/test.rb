class CircleNode
  attr_accessor :value, :prev, :next

  def initialize(value)
    @value = value
    @prev = self
    @next = self
  end

  def remove
    @prev.next = @next
    @next.prev = @prev
    @value
  end

  def insert(value)
    node = CircleNode.new(value)
    node.prev = self
    node.next = @next
    @next.prev = node
    @next = node
    node
  end
end

def high_score(player_count, last_marble)
  players = Array.new(player_count, 0)
  circle = CircleNode.new(0)

  mc = 0
  (23..last_marble).step(23) do |marble|
    (marble - 22...marble).each { |marble1| circle = circle.next.insert(marble1) }

    6.times { circle = circle.prev }
    removed_marble = circle.prev.remove

    current_player = (marble - 1) % player_count
    players[current_player] += marble + removed_marble
    mc += 1
  end

  pp mc

  players.max
end

puts high_score(30, 5807)
# puts high_score(435, 7118400)
