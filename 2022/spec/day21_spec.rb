class Day21 < Helper
  def self.parse
    cache      = {}
    operations = []
    file.split("\n").each do |line|
      name, operation = line.split(": ")
      a, op, b        = operation.split(" ")

      if op.blank?
        cache[name] = a.to_i
      else
        operations << [name, a, op, b]
      end
    end

    [cache, operations]
  end

  def self.calculate(cache, operations)
    cache_eval = {}
    while operations.present?
      found = false
      operations.each do |operation|
        next if cache[operation[1]].blank?
        next if cache[operation[3]].blank?

        calc = "#{cache[operation[1]]} #{operation[2]} #{cache[operation[3]]}"
        if calc.exclude?("==")
          cache_eval[calc]  ||= eval(calc)
          cache[operation[0]] = cache_eval[calc]
        else
          cache[operation[0]] = eval(calc)
        end

        operations.delete(operation)
        found = true
        break
      end

      break if !found
    end

    cache
  end

  def self.part1
    cache, operations = parse
    cache = calculate(cache, operations)
    cache["root"]
  end

  def self.part2
    cache, operations = parse

    cache.delete("humn")
    cache["zero"] = 0

    root_index       = operations.find_index{|oo| oo[0] == 'root' }
    _, rva, rop, rvb = operations.delete(operations[root_index])
    operations << [rvb, rva, "+", "zero"]
    operations << [rva, rvb, "+", "zero"]

    while cache["humn"].blank? do
      cache = calculate(cache, operations)

      operations.each do |target, va, op, vb|
        if cache[target] && cache[vb]
          if op == "+"
            cache[va] = cache[target] - cache[vb]
          elsif op == "-"
            cache[va] = cache[target] + cache[vb]
          elsif op == "*"
            cache[va] = cache[target] / cache[vb]
          elsif op == "/"
            cache[va] = cache[target] * cache[vb]
          end
          operations.delete([target, va, op, vb])
        end

        if cache[target] && cache[va]
          if op == "+"
            cache[vb] = cache[target] - cache[va]
          elsif op == "-"
            cache[vb] = cache[va] - cache[target]
          elsif op == "*"
            cache[vb] = cache[target] / cache[va]
          elsif op == "/"
            cache[vb] = cache[va] / cache[target]
          end
          operations.delete([target, va, op, vb])
        end
      end
    end

    cache["humn"]
  end
end

RSpec.describe "Day21" do
  it "does part 1" do
    expect(Day21.part1).to eq(82225382988628)
  end

  it "does part 2" do
    expect(Day21.part2).to eq(3429411069028)
  end
end