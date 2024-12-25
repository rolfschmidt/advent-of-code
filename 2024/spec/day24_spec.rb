class Day24 < Helper
  def self.show_bin(register, show_key)
    register.select {|key, value| key =~ /^#{show_key}\d+$/ }.to_a.sort.reverse.map { _2 }.join
  end

  def self.run_commands
    register = @register.deep_dup
    seen     = {}
    found    = true
    while found do
      found = false
      @commands.each do |cmd|
        aa, op, bb, rr = cmd

        aa = register[aa]
        bb = register[bb]
        next if aa.nil?
        next if bb.nil?
        next if seen[cmd]
        seen[cmd] = true
        found = true

        if op == 'AND'
          register[rr] =  (aa & bb).to_i
        elsif op == 'XOR'
          register[rr] =  (aa != bb).to_i
        elsif op == 'OR'
          register[rr] =  aa | bb
        end

        break
      end
    end

    register
  end

  # technically I gave up on part 2 since I did not know what a full adder is or that the input represents it.
  # I watched https://www.twitch.tv/videos/2335064966 (props to plusmid) to understand it.
  # BUT I built my own logic to solve it in ruby since 99% of people solved it by hand
  # and I would never solve a puzzle by hand.
  # https://www.build-electronic-circuits.com/full-adder/
  def self.find_circuit_fails
    (0..@zindex - 1).each_with_object(Set.new) do |ci, result|
      xid = "x%02d" % ci
      yid = "y%02d" % ci
      zid = "z%02d" % ci

      # circuit schema
      # cmd1. [x09 XOR y09 jkm]
      # -> condition contains x[ID] and y[ID] + OR
      # cmd2. [y09 AND x09 nhk]
      # -> condition contains x[ID] and y[ID] + AND
      # cmd3. [gdm XOR jkm z09]
      # -> condition contains cmd1 result + XOR || cmd result is z[ID]
      # cmd4. [gdm AND jkm ftf]
      # -> condition contains cmd1 result + AND
      # cmd5. [nhk OR ftf pvb]
      # -> condition contains cmd2 result + OR
      cmd1 = @commands.find do |cmd|
        [xid, yid].include?(cmd[0]) && cmd[1] == 'XOR' && [xid, yid].include?(cmd[2])
      end
      return if cmd1.blank?

      cmd2 = @commands.find do |cmd|
        [xid, yid].include?(cmd[0]) && cmd[1] == 'AND' && [xid, yid].include?(cmd[2])
      end

      cmd3 = @commands.select do |cmd|
        next true if (cmd[0..2].any? {|v| v == cmd1[3] } && cmd[1] == 'XOR')
        next true if cmd[3] == zid
      end

      cmd4 = @commands.find do |cmd|
        (cmd[0..2].any? {|v| v == cmd1[3] } && cmd[1] == 'AND')
      end

      cmd5 = @commands.find do |cmd|
        (cmd[0..2].any? {|v| v == cmd2[3] } && cmd[1] == 'OR')
      end

      if cmd3.count != 1
        ai = @commands.index(cmd3[0])
        bi = @commands.index(cmd3[1])

        result << @commands[ai][3]
        result << @commands[bi][3]
      end

      # first circuit is a half-adder, so ignore
      if ci != 0
        result << cmd1[3] if cmd4.nil?
        result << cmd2[3] if cmd5.nil?
      end
    end
  end

  def self.part1(part2 = false)
    register, commands = file.blocks.map(&:lines)
    @register = register.map(&:words).to_h { [_1, _2.to_i] }
    @commands = commands.map(&:words)

    register_first = run_commands
    return show_bin(register_first, 'z').to_i(2) if !part2

    @current_z  = show_bin(register_first, 'z')
    @current_za = @current_z.chars
    @zindex     = @current_za.count - 1

    find_circuit_fails.sort.join(',')
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day24" do
  it "does part 1" do
    expect(Day24.part1).to eq(56939028423824)
  end

  it "does part 2" do
    expect(Day24.part2).to eq('frn,gmq,vtj,wnf,wtt,z05,z21,z39')
  end
end