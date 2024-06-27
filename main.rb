require "Clipboard"
require "humanize"
require_relative "classic.rb"
require_relative "v2.rb"

puts "#######################################"
puts "#    D&D Beyond Rollable Generator    #"
puts "#                  v2                 #"
puts "#######################################"

puts "Select generator:"
puts "1. Attacks (default);"
puts "2. Traits;"
puts "3. Legendary actions; or"
puts "4. Classic options."
puts ""

option = gets.to_i
puts ""

case option
when 2
  attributes()
when 3
  legendary_actions()
when 4
  classic_ddb()
else
  attacks()
end