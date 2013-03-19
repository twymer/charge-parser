require_relative 'charge_parser'
require 'json'

if ARGV[0]
  filename = ARGV[0]
  results = []
  File.open(ARGV[0], 'r') do |file|
    file.each_line do |line|
      puts ChargeParser.parse(line).to_json
    end
  end
else 
  puts "Please pass a filename"
end
