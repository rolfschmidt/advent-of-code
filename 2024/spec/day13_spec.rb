class Day13 < Helper
  def self.solve_z3(ax, ay, bx, by, px, py)
    solver = Z3::Solver.new
    a      = Z3.Int('a')
    b      = Z3.Int('b')

    # will resolve variables a & b
    # and return the values if possible
    solver.assert(ax * a + bx * b == px)
    solver.assert(ay * a + by * b == py)

    return if !solver.satisfiable?

    {
      a: solver.model[a].to_i,
      b: solver.model[b].to_i,
    }
  end

  # had part 1 as loop solution (see git history)
  def self.part1(part2 = false)
    rules = file.blocks.map(&:numbers)

    rules.sum do |ax, ay, bx, by, px, py|
      if part2
        px += 10000000000000
        py += 10000000000000
      end

      result = solve_z3(ax, ay, bx, by, px, py)
      next 0 if result.blank?

      3 * result[:a] + result[:b]
    end
  end

  # gave up, props to https://www.reddit.com/r/adventofcode/comments/1hd4wda/comment/m1to61k/
  def self.part2
    part1(true)
  end
end

RSpec.describe "Day13" do
  it "does part 1" do
    expect(Day13.part1).to eq(38714)
  end

  it "does part 2" do
    expect(Day13.part2).to eq(74015623345775) # 80480204855515 48351743806770 47159309525456 145112072892096 143919638610782 83835108757394
  end
end