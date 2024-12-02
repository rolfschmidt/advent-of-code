class Day02 < Helper
  def self.check(data)
    start = nil
    inc = data.all?{|r| c = start.nil? || start < r; start = r; c }
    start = nil
    dec = data.all?{|r| c = start.nil? || start > r; start = r; c }
    start = nil
    diff  = data.all?{|r| c = start.nil? || (start - r).abs <= 3; start = r; c }

    (inc || dec) && diff
  end

  def self.part1(part2 = false)
    file.split("\n").sum do |row|
      data = row.split(" ").map(&:to_i)

      if check(data)
        1
      else
        if part2
          result = 0
          data.keys.each do |rmi|
            data_new = data.dup
            data_new.delete_at(rmi)

            if check(data_new)
              result = 1
              break
            end
          end
          result
        else
          0
        end
      end
    end
  end

  def self.part2
    part1(true)
  end
end

RSpec.describe "Day02" do
  it "does part 1" do
    expect(Day02.part1).to eq(359)
  end

  it "does part 2" do
    expect(Day02.part2).to eq(418)
  end
end