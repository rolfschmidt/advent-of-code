$LOAD_PATH.unshift(File.expand_path('spec'))

require 'rspec'
require_relative('spec/spec_helper.rb')
Dir["spec/**/*.rb"].each do |file|
  next if file.include?('day00')
  require_relative file
end

begin
  require 'pry'
  if defined?(Pry)
    Pry.start
    exit
  end
end




