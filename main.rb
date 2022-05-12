require "Clipboard"

# Final output format, with its two major fields:
final = "[rollable]OUTPUT;JSON[/rollable]"
# The part of the final output that the user will read - the contents of the
# button:
output = ""
# The JSON part of the final output, with its two mandatory parameters:
json = "{\"diceNotation\":\"DICE\",\"rollType\":\"TYPE\"OTHER}"
# An array to contain any other parameter of the JSON part:
other = []
# The rollAction parameter:
action = "\"rollAction\":\"ACTION_NAME\""
# The rollDamageType parameter:
damage = "\"rollDamageType\":\"DAMAGE_TYPE\""

# The supported rollType's:
roll_types = [
  ["roll",     "Used for a generic dice roll"],
  ["to hit",   "Used for attack rolls"],
  ["damage",   "Used for damage rolls. Should include rollDamageType when using this"],
  ["heal",     "Used for healing"],
  ["spell",    "Can be used to differentiate a spell attack from a regular attack roll"],
  ["save",     "Used for saving throws"],
  ["check",    "Used for profiency checks (skills)"],
  ["recharge", "Used for recharging abilities"]
]
# The supported rollDamageType's:
damage_types = [
  "Acid",
  "Bludgeoning",
  "Cold",
  "Fire",
  "Force",
  "Lightning",
  "Necrotic",
  "Piercing",
  "Poison",
  "Psychic",
  "Radiant",
  "Slashing",
  "Thunder"
]

puts "#######################################"
puts "#    D&D Beyond Rollable Generator    #"
puts "#######################################"

puts "What do you wish to generate? (Choose from the below)"
puts "  1. To hit;"
puts "  2. Damage (default);"
puts "  3. Heal;"
puts "  4. Recharge; or"
puts "  5. General roll."

case gets.to_i
when 1
  puts "What is the attack bonus?"
  ab = gets.to_i
  sign = (ab < 0) ? "-" : "+"

  puts "Is there a name for this attack? (Leave blank if not)"
  name = gets.strip
  if name
    action.sub!(/ACTION_NAME/, name)
    json.sub!(/OTHER/, "," + action)
  end

  puts "Is the attack a magical one? (y/N)"
  if gets.strip.downcase == "y"
    json.sub!(/TYPE/, "spell")
  else
    json.sub!(/TYPE/, "to hit")
  end

  json.sub!(/DICE/, "1d20" + sign + ab.abs.to_s)

  final.sub!(/OUTPUT/, sign + ab.abs.to_s)
       .sub!(/JSON/, json)
when 3
  puts "What is the healing amount? (Use the format NdN+/-N, where N is a natural number)"
  heal = gets.downcase.gsub!(/\s/, "")

  json.sub!(/TYPE/, "heal")

  puts "Is there a name for this action? (Leave blank if not)"
  name = gets.strip
  if name
    action.sub!(/ACTION_NAME/, name)
    json.sub!(/OTHER/, "," + action)
  end

  json.sub!(/DICE/, heal)

  final.sub!(/OUTPUT/, heal)
       .sub!(/JSON/, json)
when 4
  puts "The recharge uses 1d6? (Y/n)"
  if gets.strip.downcase == "n"
    puts "What is roll for this recharging? (Use the format NdN+/-N, where N is a natural number)"
    roll = gets.downcase.gsub!(/\s/, "")
  else
    roll = "1d6"
  end

  puts "The recharging occurs from..."
  min = gets.to_i
  puts "...to..."
  max = gets.to_i

  text = "Recharge #{min}-#{max}"

  json.sub!(/TYPE/, "recharge")

  puts "Is there a name for the action to be recharged? (Leave blank if not)"
  name = gets.strip
  if name
    action.sub!(/ACTION_NAME/, name)
    json.sub!(/OTHER/, "," + action)
  end

  json.sub!(/DICE/, roll)

  final.sub!(/OUTPUT/, text)
       .sub!(/JSON/, json)
when 5
  puts "What is the dice roll? (Use the format NdN+/-N, where N is a natural number)"
  roll = gets.downcase.gsub!(/\s/, "")
  json.sub!(/DICE/, roll)

  puts "Is the text to be shown the dice roll above? (Y/n)"
  if gets.strip.downcase == "n"
    puts "What is the text to be shown?"
    final.sub!(/OUTPUT/, gets.strip)
  else
    final.sub!(/OUTPUT/, roll)
  end

  puts "What is the type of roll? (Choose the number)"
  roll_types.each_with_index do |v, i|
    puts "  #{i.to_s.rjust(2,"0")}. #{v[0]} (#{v[1]})"
  end
  index = gets.to_i
  json.sub!(/TYPE/, roll_types[index][0])

  puts "Is there a name for this roll? (Leave blank if not)"
  name = gets.strip
  if name
    action.sub!(/ACTION_NAME/, name)
    other.push action
  end

  notice = (index == 2) ? "A damage type is MADATORY when rollType is \"damage\"." : "Optional, and may not be even shown."
  puts "Is the a damage type associated? #{notice} (Y/n)"
  if gets.strip.downcase != "n"
    puts "What is the type of damage dealt by this attack? (Choose the number)"
    damage_types.each_with_index do |v, i|
      puts "  #{i.to_s.rjust(2,"0")}. #{v}"
    end
    index = gets.to_i
    damage.sub!(/DAMAGE_TYPE/, damage_types[index])
    other.push damage
  end

  json.sub!(/OTHER/, "," + other.join(","))
  final.sub!(/JSON/, json)
else
  puts "What is the damage? (Use the format NdN+/-N, where N is a natural number)"
  dmg = gets.downcase.gsub!(/\s/, "")

  json.sub!(/TYPE/, "damage")

  puts "Is there a name for this attack? (Leave blank if not)"
  name = gets.strip
  if name
    action.sub!(/ACTION_NAME/, name)
    other.push action
  end

  puts "What is the type of damage dealt by this attack? (Choose the number)"
  damage_types.each_with_index do |v, i|
    puts "  #{i.to_s.rjust(2,"0")}. #{v}"
  end
  index = gets.to_i
  damage.sub!(/DAMAGE_TYPE/, damage_types[index])
  other.push damage

  json.sub!(/DICE/, dmg)
  json.sub!(/OTHER/, "," + other.join(","))

  final.sub!(/OUTPUT/, dmg)
  final.sub!(/JSON/, json)
end

puts "Final output: " + final
Clipboard.copy(final)
puts "Copied to clipboard!"
