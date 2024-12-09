class Day09 < Helper
  def self.part1(part2 = false)
    check = []
    on = true
    counter = 0
    file.chars.each_with_index do |value, vi|
      value = value.to_i

      value.times {|i| check << (on ? counter : '.') }
      counter += 1 if on
      on = !on
    end

    if !part2
      fi = 0
      while fi < check.size do
        if check[fi] != '.'
          fi += 1
          next
        end

        new_value = '.'
        while new_value == '.' do
          new_value = check.pop
        end

        check[fi] = new_value

        fi += 1
      end
    else

      back_start = nil
      back_end   = nil
      back_value = []
      check.keys.reverse.each do |cri|
        cr_value = check[cri]
        back_value << cr_value
        back_end = cri if back_value.size == 1

        if cr_value != check[cri - 1]
          back_start = cri

          front_start = nil
          front_end   = nil
          front_value = []
          check.keys.each do |cfi|
            break if cfi >= back_start

            cf_value = check[cfi]
            front_value << cf_value
            front_start = cfi if front_value.size == 1
            if cf_value != check[cfi + 1]
              front_end = cfi

              if cf_value == '.' && front_value.size >= back_value.size
                (0..back_value.size - 1).each do |rei|
                  check[front_start + rei], check[back_start + rei] = check[back_start + rei], check[front_start + rei]
                end

                break
              end

              front_start = nil
              front_end   = nil
              front_value = []
            end
          end

          back_start = nil
          back_end   = nil
          back_value = []
        end
      end

      result = 0
      check.each_with_index do |value, vi|
        next if value == '.'
        result += value.to_i * vi
      end

      return result
    end

    result = 0
    check.reject{ _1 == '.' }.each_with_index do |value, vi|
      result += value.to_i * vi
    end

    result
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day09" do
  it "does part 1" do
    expect(Day09.part1).to eq(6283170117911) # 89312749423 89312744865 89312744873 5547170081 5628137933
  end

  it "does part 2" do
    expect(Day09.part2).to eq(6307653242596) # 12858768099288 12859447930615 6307653502443
  end
end
