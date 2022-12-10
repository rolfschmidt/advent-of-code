require 'matrix'
require 'rails'
require 'active_support/all'
require 'pry'
require 'byebug'

class String
  def halve
    [self[0, self.size/2], self[self.size/2..-1]]
  end
end

class Helper
  def self.file
    File.read("spec/#{self.to_s.downcase}.txt")
  end

  def self.file_test
    File.read("spec/#{self.to_s.downcase}_test.txt")
  end

  def self.all_chars
    ("a".."z").to_a + ("A".."Z").to_a
  end
end

RSpec.configure do |config|
  config.default_formatter = "doc"
end
