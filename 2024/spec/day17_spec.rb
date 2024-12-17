class Day17 < Helper
  def self.parse_input(input)
    data = input.blocks.map(&:lines).flatten.map(&:numbers).flatten

    {
      'A' => data.shift,
      'B' => data.shift,
      'C' => data.shift,
      'prog' => data,
      'prog_string' => data.join(','),
    }
  end

  ADV = 0
  BXL = 1
  BST = 2
  JNZ = 3
  BXC = 4
  OUT = 5
  BDV = 6
  CDV = 7
  def self.part1(register = parse_input(file))
    prog = register['prog']

    result = ''

    progi = 0
    while progi < prog.size
      opcode          = prog[progi]
      literal_operand = prog[progi + 1]

      combo_operand = nil
      if [0, 1, 2, 3].include?(literal_operand)
        combo_operand = literal_operand
      elsif literal_operand == 4
        combo_operand = register['A']
      elsif literal_operand == 5
        combo_operand = register['B']
      elsif literal_operand == 6
        combo_operand = register['C']
      else
        combo_operand = literal_operand
      end

      # pp [opcode, literal_operand, combo_operand, register]

      inst_value = nil
      if opcode == ADV
        register['A'] /= 2 ** combo_operand
      elsif opcode == BXL
        register['B'] = register['B'] ^ literal_operand
      elsif opcode == BST
        register['B'] = combo_operand % 8
      elsif opcode == JNZ
        if register['A'] != 0
          # puts "Jump #{literal_operand}"
          progi = literal_operand
          next
        end
      elsif opcode == BXC
        register['B'] = register['B'] ^ register['C']
      elsif opcode == OUT
        inst_value = combo_operand % 8
        result += "#{inst_value},"
      elsif opcode == BDV
        register['B'] = register['A'] / (2 ** combo_operand)
      elsif opcode == CDV
        register['C'] = register['A'] / (2 ** combo_operand)
      else
        raise 'calc fail'
      end

      progi += 2
    end

    result[..-2]
  end

  def self.part2
    input    = file
#     input = "Register A: 2024
# Register B: 0
# Register C: 0

# Program: 0,3,5,4,3,0"
    register = parse_input(input)


    if 0 == 1
      5.times do
        puts Benchmark.measure {
          sti = 1
          cores = 1
          tregister = register.clone
          total = tregister['A'] + 10000000000000000
          round = tregister['A']
          while round < total do
            num = round + (sti - 1)
            # puts "#{num} of #{tregister['A'] + 10}"
            tregister['A'] = num

            if num % 1000000 == 0
              print "."
            end

            result = part1(tregister)
            if result == tregister['prog_string']
              puts num
              break
            end

            round += cores + sti - 1
          end
        }
      end

      return 0
    end


    found = []
    cores = 24
    Parallel.each((1..cores)) do |sti|
      tregister = register.clone

      total = tregister['A'] + 10000000000000000
      round = tregister['A']
      while round < total do
        num = round + (sti - 1)
        # puts "#{num} of #{tregister['A'] + 10}"
        tregister['A'] = num

        if num % 1000000 == 0
          print "."
        end

        result = part1(tregister)
        if result == tregister['prog_string']
          puts num
          raise Parallel::Break
          break
        end

        round += cores + sti - 1
      end
    end

    found.min
  end
end

# puts Day17.part1
puts Day17.part2
return

RSpec.describe "Day17" do
  it "does part 1" do
    expect(Day17.part1).to eq('1,0,2,0,5,7,2,1,3')
  end

  it "does part 2" do
    expect(Day17.part2).to eq(100)
  end
end
