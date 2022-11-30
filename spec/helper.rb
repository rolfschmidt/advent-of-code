class Helper
  def self.read_file
    File.read("spec/#{self.to_s.downcase}.txt").split
  end
end