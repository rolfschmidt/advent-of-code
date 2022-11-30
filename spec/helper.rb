class Helper
  def self.read_file(path)
    File.read("spec/#{path}").split
  end
end