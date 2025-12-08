class Day14 < Helper
  def self.part1
    recipes = Array.new(part2? ? 25_000_000 : file.to_i)
    recipes[0] = 3
    recipes[1] = 7
    recipes_count = 2

    e1 = 0
    e2 = 1
    rounds = file.to_i
    search = file.to_s.chars.map(&:to_i)
    counter = 0
    loop do
      counter += 1
      puts "#{counter} / 25000000" if counter % 5_000_000 == 0

      break if recipes_count >= rounds + 10 && !part2?

      n1 = recipes[e1]
      n2 = recipes[e2]
      newr = (n1 + n2).to_s.chars.map(&:to_i)

      newr.each do |value|
        recipes[recipes_count] = value
        recipes_count += 1
      end

      e1 = (e1 + n1 + 1) % recipes_count
      e2 = (e2 + n2 + 1) % recipes_count

      break if part2? && counter % 25_000_000 == 0
    end

    if part2?
      recipes.each_cons(search.size).with_index do |data, di|
        return di if search == data
      end
    end

    recipes[rounds, 10].join.to_i
  end

  def self.part2
    part1
  end
end

RSpec.describe "Day14" do
  it "does part 1" do
    expect(Day14.part1).to eq(3410710325)
  end

  it "does part 2" do
    expect(Day14.part2).to eq(20216138) # 3710101245 5421010173
  end
end
