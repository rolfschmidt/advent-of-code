class Day19 < Helper
  def self.workflows
    @workflows ||= file.split("\n\n").map{|data| data.split("\n") }.first
  end

  def self.lines
    @lines ||= file.split("\n\n").map{|data| data.split("\n") }.second
  end

  def self.add_subs
    workflow_subs = workflows.map do |cw|
      raise if cw !~ /(\w+)\{(.+)\}/
      name = $1
      rule = $2

      rule = rule.split(",").map do |r|
        if r.include?(':')
          raise if r !~ /^(\w+)(\>|\<)(-?\d+)\:(\w+)$/

          rule_name     = $1
          rule_operator = $2
          rule_value    = $3.to_i
          rule_cw       = $4

          rule_range = ""
          if rule_operator == '>'
            rule_range = "((#{rule_value} + 1)..4000)"
          else
            rule_range = "(1..(#{rule_value} - 1))"
          end

          "
          check = Array.wrap(#{rule_name}).intersect_range(#{rule_range})
          if check.present?
            cx, cm, ca, cs = ddup(x), ddup(m), ddup(a), ddup(s)
            c#{rule_name}  = ddup(check)
            #{rule_name}   = Array.wrap(#{rule_name}).sub_range(#{rule_range})
            total         += sub_#{rule_cw}(cx, cm, ca, cs)
          end
          "
        else
          "
          total += sub_#{r}(x, m, a, s)
          "
        end
      end.join("\n          ")

      "
      def sub_#{name}(x, m, a, s)
        total = []
        #{rule}
        total
      end"
    end

    workflow_subs << "def sub_A(x, m, a, s); [[x, m, a, s]]; end"
    workflow_subs << "def sub_R(x, m, a, s); []; end"

    instance_eval(workflow_subs.join("\n"))
  end

  def self.part1
    add_subs

    lines.sum do |line|
      next 0 if sub_in(*line.numbers.ensure_ranges).none?{|v| v.all?(&:present?) }

      line.numbers.sum
    end
  end

  def self.part2
    add_subs

    fk = [(1..4000)]
    sub_in(fk, fk, fk, fk).sum do |r|
      r.map{|v| v.rangify.map(&:count).sum }.inject(:*)
    end
  end
end

RSpec.describe "Day19" do
  it "does part 1" do
    expect(Day19.part1).to eq(480738)
  end

  it "does part 2" do
    expect(Day19.part2).to eq(131550418841958)
  end
end