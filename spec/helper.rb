class String
  def halve
    [self[0, self.size/2], self[self.size/2..-1]]
  end
end

class Helper
  def self.file_string
    File.read("spec/#{self.to_s.downcase}.txt")
  end

  def self.all_chars
    ("a".."z").to_a + ("A".."Z").to_a
  end
end