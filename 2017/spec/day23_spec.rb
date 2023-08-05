class Program
  attr_accessor :cmds, :i, :mem, :halt, :mul_count

  def initialize(cmds, mem = {})
    @cmds = cmds
    @i = 0
    @mem = mem
    @halt = false
    @mul_count = 0
  end

  def halt?
    halt
  end

  def run
    return if halt?

    cmd = cmds[i]

    case cmd
    when /^(set|sub|mul|jnz) (\w+) (.+?)$/
      op = $1
      v1 = $2
      v2 = $3

      to = v2
      if to =~ /^[a-z]+$/
        @mem[to] ||= 0
        to = mem[to]
      else
        to = to.to_i
      end
      
      case op
      when 'set'
        @mem[v1] ||= 0
        @mem[v1] = to
      when 'sub'
        @mem[v1] ||= 0
        @mem[v1] -= to
      when 'mul'
        @mul_count += 1
        @mem[v1] ||= 0
        @mem[v1] *= to
      when 'jnz'
        v1 = if v1 =~ /^[a-z]+$/
          @mem[v1] || 0
        else
          v1 = v1.to_i
        end

        if v1 != 0
          @i += to
          return true
        end
      else
        raise v1.to_s
      end
    else
      @halt = true
      return true
    end

    @i += 1

    return true
  end
end

class Day23 < Helper
  def self.part1
    cmds = file.split("\n")
    prog = Program.new(cmds)

    loop do
      prog.run

      break if prog.halt?
    end

    return prog.mul_count
  end

  def self.part2
    a = 1
    b = 0
    c = 0
    d = 0
    e = 0
    f = 0
    g = 0
    h = 0
    b = 99
    c = b
    if a != 0
      b = b * 100 + 100000
      c = b + 17000
    end
    loop do
      f = 1

      (2..b - 1).each do |d|
        if b % d == 0
          f = 0
          break
        end
      end

      # d = 2
      # loop do
      #   e = 2
      #   loop do
      #     if d * e == b
      #       f = 0
      #     end
      #     e += 1
      #     break if e == b
      #   end
      #   d += 1
      #   break if d == b
      # end
      if f == 0
        h += 1
      end
      break if b == c
      b += 17
    end

    h
  end
end

RSpec.describe "Day23" do
  it "does part 1" do
    expect(Day23.part1).to eq(9409)
  end

  it "does part 2" do 
    expect(Day23.part2).to eq(913)
  end
end