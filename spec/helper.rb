class Helper
  def self.file_string
    File.read("spec/#{self.to_s.downcase}.txt")
  end
end