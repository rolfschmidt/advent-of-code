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
          r = r.gsub(':', ' ? sub_')
          r = "#{r}"
          "(#{r}(x, m, a, s) : nil)"
        else
          "sub_#{r}(x, m, a, s)"
        end
      end.reduce do |a, b|
        a.sub('nil', b)
      end

      "def sub_#{name}(x, m, a, s); #{rule}; end"
    end

    workflow_subs << "def sub_A(x, m, a, s); 1; end"
    workflow_subs << "def sub_R(x, m, a, s); 0; end"
    instance_eval(workflow_subs.join("\n"))
  end

  def self.part1
    add_subs

    total = 0
    lines.each do |line|
      x, m, a, s = line.numbers
      result = sub_in(x, m, a, s)
      if result > 0
        total += x + m + a + s
      end
    end

    total
  end

  def self.add_subs_part2
    workflow_subs = workflows.map do |cw|
      raise if cw !~ /(\w+)\{(.+)\}/
      name = $1
      rule = $2

      rule = rule.split(",").map do |r|
        if r.include?(':')
          raise if r !~ /^(\w+)(\>|\<)(-?\d+)\:(\w+)$/

          rule_name = $1
          rule_operator = $2
          rule_value = $3.to_i
          rule_cw = $4

          rule_range = ""
          if rule_operator == '>'
            rule_range = "((#{rule_value} + 1)..4000)"
          else
            rule_range = "(1..(#{rule_value} - 1))"
          end

          "
          check = Array.wrap(#{rule_name}).rangify.map{|r| r & #{rule_range} }.flatten.compact
          if check.present?
            cx, cm, ca, cs = ddup(x), ddup(m), ddup(a), ddup(s)
            c#{rule_name}  = ddup(check)
            #{rule_name}   = Array.wrap(#{rule_name}).rangify.map{|r| r - #{rule_range} }.flatten.compact
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

    workflow_subs << "def sub_A(x, m, a, s); [{x: x, m: m, a: a, s: s}]; end"
    workflow_subs << "def sub_R(x, m, a, s); []; end"

    instance_eval(workflow_subs.join("\n"))
  end

  def self.part2
    add_subs_part2

    fk = [(1..4000)]
    tx = []
    tm = []
    ta = []
    ts = []
    total = 0
    sub_in(fk, fk, fk, fk).select{|v| v.is_a?(Hash) }.each do |r|
      r[:x] = r[:x].rangify.map(&:count).sum
      r[:m] = r[:m].rangify.map(&:count).sum
      r[:a] = r[:a].rangify.map(&:count).sum
      r[:s] = r[:s].rangify.map(&:count).sum
      total += r.values.inject(:*)
    end

    total
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