class Day02 < Helper
  def self.part1
    points_map = {
      'rock' => 1,
      'paper' => 2,
      'sci' => 3,
    }
    map = {
      'A' => 'rock',
      'B' => 'paper',
      'C' => 'sci',
      'X' => 'rock',
      'Y' => 'paper',
      'Z' => 'sci',
    }

    games = file_string.split("\n").map{|g|
      v = g.split(" ")
      [map[v[0]], map[v[1]]]
    }

    points = 0
    games.each do |game|
      result = 0
      if game[1] == 'rock' && game[0] == 'rock'
        result = 0
      elsif game[1] == 'rock' && game[0] == 'paper'
        result = -1
      elsif game[1] == 'rock' && game[0] == 'sci'
        result = 1
      elsif game[1] == 'paper' && game[0] == 'rock'
        result = 1
      elsif game[1] == 'paper' && game[0] == 'paper'
        result = 0
      elsif game[1] == 'paper' && game[0] == 'sci'
        result = -1
      elsif game[1] == 'sci' && game[0] == 'rock'
        result = -1
      elsif game[1] == 'sci' && game[0] == 'paper'
        result = 1
      elsif game[1] == 'sci' && game[0] == 'sci'
        result = 0
      end

      if result == 1
        points += points_map[game[1]]
        points += 6
      elsif result == -1
        points += points_map[game[1]]
      else
        points += points_map[game[1]]
        points += 3
      end
    end

    points
  end

  def self.part2
    points_map = {
      'rock' => 1,
      'paper' => 2,
      'sci' => 3,
    }
    map = {
      'A' => 'rock',
      'B' => 'paper',
      'C' => 'sci',
      'X' => 'lose',
      'Y' => 'draw',
      'Z' => 'win',
    }

    games = file_string.split("\n").map{|g|
      v = g.split(" ")
      [map[v[0]], map[v[1]]]
    }

    points = 0
    games.each do |game|
      result = 0
      if game[1] == 'lose' && game[0] == 'rock'
        result = -1
        game[1] = 'sci'
      elsif game[1] == 'lose' && game[0] == 'paper'
        result = -1
        game[1] = 'rock'
      elsif game[1] == 'lose' && game[0] == 'sci'
        result = -1
        game[1] = 'paper'
      elsif game[1] == 'draw' && game[0] == 'rock'
        result = 0
        game[1] = 'rock'
      elsif game[1] == 'draw' && game[0] == 'paper'
        result = 0
        game[1] = 'paper'
      elsif game[1] == 'draw' && game[0] == 'sci'
        result = 0
        game[1] = 'sci'
      elsif game[1] == 'win' && game[0] == 'rock'
        result = 1
        game[1] = 'paper'
      elsif game[1] == 'win' && game[0] == 'paper'
        result = 1
        game[1] = 'sci'
      elsif game[1] == 'win' && game[0] == 'sci'
        result = 1
        game[1] = 'rock'
      end

      if result == 1
        points += points_map[game[1]]
        points += 6
      elsif result == -1
        points += points_map[game[1]]
      else
        points += points_map[game[1]]
        points += 3
      end
    end

    points
  end
end

RSpec.describe "Day02" do
  it "does part 1" do
    expect(Day02.part1).to eq(10941)
  end

  it "does part 2" do
    expect(Day02.part2).to eq(13071)
  end
end