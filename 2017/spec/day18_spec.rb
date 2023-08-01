class Program
  attr_accessor :id, :cmds, :i, :mem, :last_snd, :snd_count, :halt, :wait, :queue, :other

  def initialize(cmds, id = nil)
    @id = id
    @cmds = cmds
    @i = 0
    @mem = { 'p' => id }
    @halt = false
    @wait = false
    @snd_count = 0
    @queue = []
  end

  def set_target(prog)
    @other = prog
  end

  def wait?
    wait
  end

  def halt?
    halt
  end

  def run
    return if halt?

    cmd = cmds[i]

    # puts "prog #{id} | cmd #{cmd} | i: #{i} | queue: #{queue[-5..].inspect} (#{queue.count}) | mem: #{mem.inspect}"

    case cmd
    when /^(set|add|mul|mod|jgz) (\w+) (.+?)$/
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
      when 'add'
        @mem[v1] ||= 0
        @mem[v1] += to
      when 'mul'
        @mem[v1] ||= 0
        @mem[v1] *= to
      when 'mod'
        @mem[v1] ||= 0
        @mem[v1] %= to
      when 'jgz'
        v1 = if v1 =~ /^[a-z]+$/
          @mem[v1] || 0
        else
          v1 = v1.to_i
        end

        if v1 > 0
          @i += to
          # @i = (@i + to) % cmds.size
          return true
        end
      else
        raise v1.to_s
      end
    when /^snd (\w+)$/
      to = $1
      if to =~ /^[a-z]+$/
        @mem[to] ||= 0
        to = mem[to]
      else
        to = to.to_i
      end

      @last_snd = to
      @snd_count += 1
      if other
        other.queue << to
      end
    when /^rcv (\w+)$/
      to = $1
      if other
        if queue.present?
          @wait = false
          @mem[to] = queue.shift
        else
          @wait = true
          return true
        end
      else
        @halt = true
      end
    else
      raise cmd
    end

    @i += 1

    return true
  end
end

class Day18 < Helper
  def self.part1
    cmds = file.split("\n")
    prog = Program.new(cmds)

    loop do
      prog.run

      break if prog.halt?
    end

    return prog.last_snd
  end

  def self.part2
    cmds = file.split("\n")

    prog0 = Program.new(cmds, 0)
    prog1 = Program.new(cmds, 1)
    prog0.set_target(prog1)
    prog1.set_target(prog0)

    loop do
      prog0.run
      prog1.run

      break if prog0.halt? && prog1.halt?
      break if prog0.wait? && prog1.wait?
    end

    return prog1.snd_count
  end
end

RSpec.describe "Day18" do
  it "does part 1" do
    expect(Day18.part1).to eq(1187)
  end

  it "does part 2" do 
    expect(Day18.part2).to eq(5969)
  end
end