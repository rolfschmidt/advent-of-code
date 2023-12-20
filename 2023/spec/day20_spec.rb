class Day20 < Helper
  def self.signal(from, from_signal, to, to_signal)
    next_signal = nil
    if to == 'broadcaster'
      next_signal = to_signal
    elsif to.starts_with?('%')
      # flip-flop/flipper
      # if low/false - next high/true
      # if high/true - next nil
      if from_signal == false
        to_signal = !to_signal
        next_signal = to_signal
      end
    elsif to.starts_with?('&')
      # conjunction/conji
      # if high all - next low
      # if not high all - next high
      to_signal[from] = from_signal

      if to_signal.values.all?{|v| v == true }
        next_signal = false
      else
        next_signal = true
      end
    else
      to_signal = from_signal
    end

    [to_signal, next_signal]
  end

  def self.part1(part2 = false)
    modules = file.split("\n").to_h do |line|
      from, to = line.split(" -> ")
      to = to.split(", ")
      key = from.gsub(/[\%|\&]/, '')
      [key, {
        key: key,
        from: from,
        to: to,
        state: from.include?('&') ? {} : false,
      }]
    end

    conjis = modules.keys.select{|m| modules[m][:from].include?('&') }
    modules.keys.each do |key|

      # add defaults for "to"-fields
      modules[key][:to].each do |to|
        modules[to] ||= { key: to, from: to, to: [], state: false}
      end

      # conji defaults
      (modules[key][:to] & conjis).each do |r|
        modules[r][:state][modules[key][:from]] = false
      end
    end

    # rx related
    rx_parent              = modules.values.find{|mod| (mod[:to] & ['rx']).count.positive? }
    rx_parent_states       = rx_parent[:state].keys.map{|key| key.gsub(/[\%|\&]/, '') }
    rx_parent_states_round = rx_parent_states.to_h{|key| [key, []] }

    counter_low = 0
    counter_high  = 0
    (!part2 ? 1000 : 10000000).times do |round|
      queue = [['broadcaster', false, 'broadcaster']]
      while queue.present?
        from, from_signal, to = queue.shift
        if from_signal == true
          counter_low += 1
        elsif from_signal == false
          counter_high += 1
        end

        from_mod  = modules[from]
        check_mod = modules[to]

        check_mod[:state], next_signal = signal(from_mod[:from], from_signal, check_mod[:from], check_mod[:state])

        if !next_signal.nil?
          check_mod[:to].each do |sub_to|
            # puts "#{check_mod[:key]} #{(next_signal == false ? '-low' : '-high')}-> #{sub_to}"

            if part2 && rx_parent_states.include?(check_mod[:key]) && sub_to == rx_parent[:key] && next_signal == true
              rx_parent_states_round[check_mod[:key]] |= [round]
            end

            queue << [ check_mod[:key], next_signal, sub_to]
          end
        end

        break if modules.keys.all?{|m| modules[m][:state] == false }
      end

      if part2 && rx_parent_states_round.values.all?{|c| c.size > 2 }
        return rx_parent_states_round.values.map{|v| v[-1] - v[-2] }.uniq.inject(&:lcm)
      end
    end

    counter_low * counter_high
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day20" do
  it "does part 1" do
    expect(Day20.part1).to eq(1020211150)
  end

  it "does part 2" do # 238815727638558 2503951897740972199290000 2503951897740972199300001 115445948969729131692539024986082740438612865010000
    expect(Day20.part2).to eq(238815727638557)
  end
end