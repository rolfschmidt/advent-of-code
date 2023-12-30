class Stone
  attr_accessor :pos, :vel

  def initialize(x, y, z, vx, vy, vz)
    @pos = Vector3.new(BigDecimal(x), BigDecimal(y), BigDecimal(z))
    @vel = Vector3.new(BigDecimal(vx), BigDecimal(vy), BigDecimal(vz))
  end
end

class Day24 < Helper
  def self.stones
    @stones ||= file.split("\n").map{|line| Stone.new(*line.numbers) }
  end

  def self.will_crosspath?(object1, object2, low, high)

    # Calculate the parameters of the line equations for the objects
    slope1 = object1.vel.y / object1.vel.x
    intercept1 = object1.pos.y - slope1 * object1.pos.x
    slope2 = object2.vel.y / object2.vel.x
    intercept2 = object2.pos.y - slope2 * object2.pos.x

    # Calculate the x-coordinate of the intersection point
    intersection_x = (intercept2 - intercept1) / (slope1 - slope2)

    # Calculate the time it takes for each object to reach the intersection point
    time_to_intersection1 = (intersection_x - object1.pos.x) / object1.vel.x
    time_to_intersection2 = (intersection_x - object2.pos.x) / object2.vel.x

    return if time_to_intersection1 < 0
    return if time_to_intersection2 < 0

    solution_range = (low..high)
    return if !solution_range.cover?(intersection_x)

    intersection_y = slope1 * intersection_x + intercept1
    solution_range.cover?(intersection_y)
  end

  # gave up
  # after aoc i built this solution with @jingchan (big thx) together.
  def self.part1
    stones.combination(2).sum do |s1, s2|
      next 0 if !will_crosspath?(s1, s2, 200000000000000, 400000000000000)
      1
    end
  end

  def self.crosspath_point(object1, object2)
    # Calculate the parameters of the line equations for the objects
    slope1 = object1.vel.y / object1.vel.x
    intercept1 = object1.pos.y - slope1 * object1.pos.x

    slope2 = object2.vel.y / object2.vel.x
    intercept2 = object2.pos.y - slope2 * object2.pos.x

    # Calculate the x-coordinate of the intersection point
    intersection_x = (intercept2 - intercept1) / (slope1 - slope2)
    intersection_y = slope1 * intersection_x + intercept1

    # Calculate the time it takes for each object to reach the intersection point
    time_to_intersection1 = (intersection_x - object1.pos.x) / object1.vel.x
    time_to_intersection2 = (intersection_x - object2.pos.x) / object2.vel.x
    return nil if time_to_intersection1 < 0 || time_to_intersection2 < 0

    [intersection_x, intersection_y, time_to_intersection1]
  end

  def self.calc_intersection_error(guess)
    intersections = stones.first(10).each_cons(2).map do |a, b|
      s1 = ddup(a)
      s2 = ddup(b)

      # Multiply velocity to reduce floating point issues.
      s1.vel *= 1_000_000_000_000
      s2.vel *= 1_000_000_000_000

      # Step 1: project to plane perpendicular to guess
      s1.pos = s1.pos - guess * s1.pos.product(guess)
      s2.pos = s2.pos - guess * s2.pos.product(guess)
      s1.vel = s1.vel - guess * s1.vel.product(guess)
      s2.vel = s2.vel - guess * s2.vel.product(guess)

      crosspath_point(s1, s2)
    end

    # If any intersections are nil, set error to infinity
    return Float::INFINITY if intersections.any? { |i| i.nil? }

    # Else calculate sum of squared errors between each consecutive intersection point
    error = 0
    intersections.each_cons(2) do |result1, result2|
      p1 = Vector3.new(result1[0], result1[1], 0.0)
      p2 = Vector3.new(result2[0], result2[1], 0.0)

      error += (p2 - p1).r
    end

    [error, intersections]
  end

  def self.mass_guess
    error = Float::INFINITY
    guess = []
    while error == Float::INFINITY
      error = 0
      guess = Vector3.random.normalize
      error, _ = calc_intersection_error(guess)
    end

    puts "guessing #{error}..."

    delta = BigDecimal("0.1")

    counter = 0
    while error > 0.0000000001
      counter += 1
      raise if counter > 200 # just rerun the function if it takes too long

      new_guess = Vector3.random.normalize
      new_error, _ = calc_intersection_error(new_guess)
      if new_error < error
        error = new_error
        guess = new_guess
        delta = BigDecimal("0.1")
        next
      end

      guess_update = Vector3.random.normalize * delta
      new_guess = (guess + guess_update).normalize
      new_error, _ = calc_intersection_error(new_guess)
      if new_error < error
        error = new_error
        guess = new_guess
        next
      end

      new_guess = (guess - guess_update).normalize
      new_error, _ = calc_intersection_error(new_guess)
      if new_error < error
        error = new_error
        guess = new_guess
        next
      end

      [
        Vector3.new(1.0, 0.0, 0.0),
        Vector3.new(-1.0, 0.0, 0.0),
        Vector3.new(0.0, 1.0, 0.0),
        Vector3.new(0.0, -1.0, 0.0),
        Vector3.new(0.0, 0.0, 1.0),
        Vector3.new(0.0, 0.0, -1.0),
      ].each do |v|
        guess_update = v.normalize * delta
        new_guess = (guess + guess_update).normalize
        new_error, _ = calc_intersection_error(new_guess)
        if new_error < error
          error = new_error
          guess = new_guess
          next
        end
      end

      delta /= 2
    end

    guess
  rescue
    retry
  end

  # gave up
  # after aoc i built this solution with @jingchan (big thx) together.
  def self.part2
    guess = mass_guess

    _, intersections = calc_intersection_error(guess)
    p1 = stones[0].pos
    v1 = stones[0].vel * 1_000_000_000_000
    p2 = stones[1].pos
    v2 = stones[1].vel * 1_000_000_000_000
    time1 = intersections[0][2]
    time2 = intersections[1][2]

    ans_p1 = p1 + v1 * time1
    ans_p2 = p2 + v2 * time2
    ans_vel = (ans_p2 - ans_p1) * (1.0 / (time2 - time1))
    ans_pos = ans_p1 - ans_vel * time1

    return (ans_pos.x + ans_pos.y + ans_pos.z).round.to_int
  end
end

RSpec.describe "Day24" do
  it "does part 1" do # 11305 10842
    expect(Day24.part1).to eq(12015)
  end

  it "does part 2" do
    expect(Day24.part2).to eq(1016365642179116)
  end
end

