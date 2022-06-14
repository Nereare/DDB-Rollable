# The 5E damage types available
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
# The final damage type rolled
type = nil
# The damage to roll, if given
damage = ""
# The processed damage as XdY+MOD
dmg_x = 0
dmg_y = 0
dmg_mod = 0
# The final damage amount
dmg = 0
dmg_str = ""

puts "#######################################"
puts "#    D&D Random Damage Type Roller    #"
puts "#######################################"

puts "1. Do you wish to roll the damage as well? (y/N)"
if gets.strip.downcase == "y"
  puts "What is the damage amount? (Use the format NdN+/-N, where N is a natural number)"
  damage = gets.downcase.gsub!(/\s/, "")
  if !damage[/(\d+)d(\d+)(\+|-\d+)?/]
    puts "The damage format is invalid."
    exit 0
  end

  dmg_x = damage[/(\d+)d(\d+)([\+\-]\d+)?/, 1].to_i
  dmg_y = damage[/(\d+)d(\d+)([\+\-]\d+)?/, 2].to_i
  dmg_mod = damage[/(\d+)d(\d+)([\+\-]\d+)?/, 3].to_i
end

# Choose the damage type
rnd = Random.new
type = damage_types[ rnd.rand( 0..(damage_types.length) ) ]

if damage != ""
  dmg_str = "("
  dmg_x.times do
    dmg += rnd.rand( dmg_y ) + 1
    dmg_str += "#{dmg} + "
  end
  dmg_str.sub!(/.*\K \+ /, "")
  dmg += dmg_mod
  sign = (dmg_mod < 0) ? "" : "+"
  dmg_str += ") #{sign}#{dmg_mod}"

  # There are no negative or null damage, it will always be, at least, 1 point
  if dmg <= 0
    dmg_str += " = #{dmg} ==> 1"
    dmg = 1
  end

  # Output the damage's amount and type
  puts "We rolled for #{dmg} [#{dmg_str}] points of #{type} damage."
else
  # Output the damage type only
  puts "We rolled for #{type} damage."
end
