require "Clipboard"
require "humanize"
require_relative "rand-dmg.rb"
require_relative "robe-useful-items.rb"
require_relative "classic.rb"
require_relative "v2.rb"

puts "#######################################"
puts "#    D&D Beyond Rollable Generator    #"
puts "#                  v2                 #"
puts "#######################################"

puts "Select generator:"
puts "1. Attacks (default);"
puts "2. Traits;"
puts "3. Legendary actions;"
puts "4. Robe of Useful Items (contents generator);"
puts "5. Random Damage Generator; or"
puts "6. Classic options."
puts ""

option = gets.to_i
puts ""

case option
when 2
  attributes()
when 3
  legendary_actions()
when 4
  robe_useful_items()
when 5
  rnd_damage()
when 6
  classic_ddb()
else
  attacks()
end