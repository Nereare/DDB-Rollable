# Final output format, with its two major fields:
FINAL = "[rollable]OUTPUT;JSON[/rollable]"
# The JSON part of the final output, with its two mandatory parameters:
JSON = "{\"diceNotation\":\"DICE\",\"rollType\":\"TYPE\"OTHER}"
# An array to contain any other parameter of the JSON part:
OTHER = []
# The rollAction parameter:
ACTION = "\"rollAction\":\"ACTION_NAME\""
# The rollDamageType parameter:
DAMAGE = "\"rollDamageType\":\"DAMAGE_TYPE\""
# The supported rollDamageType's:
DAMAGE_TYPES = [
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

# Option #1/Default - Attacks
def attacks
  attacks = []
  foo = ""

  # Has multiattack?
  puts "Does the creature have the \"Multiattack\" attack? (y/N)"
  if gets.strip.downcase == "y"
    # Open paragraph and include multiattack name
    attack = "<p><strong>Multiattack.</strong>. "
    # Get multiattack text
    puts "Text for the multiattack:"
    attack << gets_clipboard()
    # Close paragraph
    attack << "</p>"

    # Show final multiattack
    puts "Final attack:"
    puts attack
    puts ""

    # Inject into array
    attacks.push(attack)
    # Announce next step
    puts "Now, to the actual attacks..."
    puts ""
  end

  # Loop to get all attacks
  while foo != "n"
    # Inject into array
    attacks.push(get_attack())
    # Check to add another
    puts "Add another? (Y/n)"
    foo = gets.strip.downcase
    puts ""
  end

  # Once all attacks added, check how many
  if attacks.length > 0
    # Show total number
    puts "Total of " + attacks.length.to_s + " attack(s)."
    # Compile final string
    final = attacks.join("\n")
    # Copy final string to clipboard
    Clipboard.copy(final)
    puts "Copied to clipboard!"
  end
end
# Sub-method: create attack
def get_attack
  attack = "<p>"

  # Show attack options
  puts "Select type of attack:"
  puts "1. Basic attack (default);"
  puts "2. Breath weapon; or"
  puts "3. Custom."

  case gets.to_i
  when 2
    action = ACTION.dup
    json = JSON.dup
    final = FINAL.dup

    # Get breath weapon name
    puts "Breath attack name:"
    atk_name = gets.strip
    attack << "<strong>" + atk_name + " ("
    action.sub!(/ACTION_NAME/, atk_name)
    json.sub!(/OTHER/, "," + action)

    # Get recharge data
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

    # Set rollable text
    recharge_text = "Recharge #{min}-#{max}"
    # Set rollable type
    json.sub!(/TYPE/, "recharge")
    # Set rollable dice
    json.sub!(/DICE/, roll)
    # Set final rollable text
    final.sub!(/OUTPUT/, recharge_text)
    final.sub!(/JSON/, json)

    # Add rollable to name
    attack << final + ").</strong> "

    # Get breath attack text
    puts "Breath attack text:"
    atk_text = gets_clipboard()
    # Check for dice rolls
    if /\d+d\d+([-\+]\d+)?/.match?(atk_text)
      puts "Your text contains dice rolls, process them? (Y/n)"
      if gets.strip.downcase != "n"
        atk_text = process_dmg_rolls(atk_text, atk_name)
      end
    end
    attack << atk_text
    # Close paragraph
    attack << "</p>"
  when 3
    # Get custom attack name
    puts "Attack name:"
    atk_name = gets.strip
    attack << "<strong>" + atk_name + ".</strong> "
    # Get custom attack text
    puts "Attack text:"
    atk_text = gets_clipboard()
    # Check for dice rolls
    if /\d+d\d+([-\+]\d+)?/.match?(atk_text)
      puts "Your text contains dice rolls, process them? (Y/n)"
      if gets.strip.downcase != "n"
        atk_text = process_dmg_rolls(atk_text, atk_name)
      end
    end
    attack << atk_text
    # Close paragraph
    attack << "</p>"
  else
    # Get attack name
    puts "Attack name:"
    atk_name = gets.strip
    attack << "<strong>" + atk_name + ".</strong> "

    # Get melee Vs. ranged
    puts "Attack is melee (1, default), ranged (2), or either (3)?"
    case gets.to_i
    when 2
      atk_range = "Ranged"
    when 3
      atk_range = "Melee or Ranged"
    else
      atk_range = "Melee"
    end
    # Get weapon Vs. spell
    puts "Attack if physical (1, default) or magic (2)?"
    atk_type = gets.to_i == 2 ? "Spell" : "Weapon"
    # Compile attack type
    attack << "<em>" + atk_range + " " + atk_type + " Attack</em> "

    # Get attack bonus
    puts "Whats the attack bonus?"
    atk_bonus = gets.to_i
    # Append attack bonus rollable
    attack << get_attack_bonus(atk_bonus, atk_type, atk_name)
    attack << " to hit, "

    # Get range/reach
    if atk_range == "Melee"
      puts "What's the reach (ft.) of the attack?"
      atk_reach = gets.to_i
      attack << "reach " + atk_reach.to_s + " ft."
    elsif atk_range == "Ranged"
      atk_range = ""
      puts "What's the short range (ft.) of the attack?"
      atk_range << "range " + gets.to_i.to_s
      puts "And the long range (ft.)?"
      long = gets.to_i
      if long == 0
        atk_range << " ft."
      else
        atk_range << "/" + long.to_i.to_s + " ft."
      end
      attack << atk_range
    else
      # Reach half
      puts "What's the reach (ft.) of the attack?"
      atk_reach = gets.to_i
      attack << "reach " + atk_reach.to_s + " ft. or "
      # Range half
      atk_range = ""
      puts "What's the short range (ft.) of the attack?"
      atk_range << "range " + gets.to_i.to_s
      puts "And the long range (ft.)?"
      long = gets.to_i
      if long == 0
        atk_range << " ft."
      else
        atk_range << "/" + long.to_i.to_s + " ft."
      end
      attack << atk_range
    end
    attack << ", "

    # Get number of targets
    puts "How many targets? (Defaul = 1)"
    no = gets.strip
    atk_targets = no.empty? ? 1 : no.to_i
    if atk_targets <= 10
      attack << atk_targets.humanize + (atk_targets > 1 ? " targets" : " target")
    else
      attack << atk_targets.to_s + " targets"
    end
    attack << ". "

    # Get damage
    puts "What is the damage? (Use the format NdN+/-N, where N is a natural number)"
    atk_dmg = gets.downcase.gsub!(/\s/, "")
    puts "What is the damage's type?"
    DAMAGE_TYPES.each_with_index do |v, i|
      puts "  #{i.to_s.rjust(2,"0")}. #{v}"
    end
    index = gets.to_i
    atk_dmg_type = DAMAGE_TYPES[index].downcase
    attack << "<em>Hit:</em> " + get_mean_damage(atk_dmg).to_s + " (" + get_damage_rollable(atk_dmg, atk_dmg_type, atk_name) + ") " + atk_dmg_type + " damage"

    # Check secondary damage
    puts "Is there a secondary damage dealt? (y/N)"
    if gets.strip.downcase == "y"
      attack << " plus "
      # Get secondary damage
      puts "What is the secondary damage? (Use the format NdN+/-N, where N is a natural number)"
      atk2_dmg = gets.downcase.gsub!(/\s/, "")
      puts "What is the secondary damage's type?"
      DAMAGE_TYPES.each_with_index do |v, i|
        puts "  #{i.to_s.rjust(2,"0")}. #{v}"
      end
      index2 = gets.to_i
      atk2_dmg_type = DAMAGE_TYPES[index2].downcase
      attack << get_mean_damage(atk2_dmg).to_s + " (" + get_damage_rollable(atk2_dmg, atk2_dmg_type, atk_name) + ") " + atk2_dmg_type + " damage"
    end

    # Check if extra text
    puts "Is there any extra text? (y/N)"
    if gets.strip.downcase == "y"
      extra_text = gets_clipboard()
      # Check for dice rolls
      if /\d+d\d+([-\+]\d+)?/.match?(extra_text)
        puts "Your text contains dice rolls, process them? (Y/n)"
        if gets.strip.downcase != "n"
          extra_text = process_dmg_rolls(extra_text, atk_name)
        end
      end
      # Remove extra final dot
      extra_text.gsub!(/\.$/, "")
      attack << extra_text
    end

    # Close paragraph
    attack << ".</p>"
  end

  # Show final attack
  puts "Final attack:"
  puts attack
  puts ""

  # Return attack
  return attack
end
# Sub-method - Get damage rollable
def get_damage_rollable(dice_notation, damage_type, name)
  action = ACTION.dup
  damage = DAMAGE.dup
  other = OTHER.dup
  json = JSON.dup
  final = FINAL.dup

  # Set rollable type
  json.sub!(/TYPE/, "damage")
  # Set rollable name
  action.sub!(/ACTION_NAME/, name)
  other.push action
  # Set rollable damage type
  damage.sub!(/DAMAGE_TYPE/, damage_type)
  other.push damage
  # Set rollable damage
  json.sub!(/DICE/, dice_notation)
  # Append misc rollable data
  json.sub!(/OTHER/, "," + other.join(","))
  # Compile rollable
  final.sub!(/OUTPUT/, dice_notation)
  final.sub!(/JSON/, json)

  return final
end
# Sub-method - Get mean damage
def get_mean_damage(dice_notation)
  dice_count, dice_type, dmg_bonus = dice_notation.match(/(\d+)d(\d+)([-\+]\d+)?/).captures
  dice_count = dice_count.to_f
  dice_type = dice_type.to_f
  dmg_bonus = dmg_bonus.to_f

  dmg = (1.0 + dice_type) / 2.0
  dmg = dmg * dice_count
  dmg = dmg + dmg_bonus

  return dmg.to_i
end
# Sub-method - Process damage bonus
def get_attack_bonus(bonus, type, name)
  action = ACTION.dup
  json = JSON.dup
  final = FINAL.dup

  # Set rollable name
  action.sub!(/ACTION_NAME/, name)
  json.sub!(/OTHER/, "," + action)

  # Set rollable type
  if type.strip.downcase == "spell"
    json.sub!(/TYPE/, "spell")
  else
    json.sub!(/TYPE/, "to hit")
  end

  # Set rollable roll
  sign = (bonus < 0) ? "-" : "+"
  json.sub!(/DICE/, "1d20" + sign + bonus.abs.to_s)

  # Compile rollable
  final.sub!(/OUTPUT/, sign + bonus.abs.to_s)
  final.sub!(/JSON/, json)
  return final
end
# Sub-method - Process damage rolls
def process_dmg_rolls(txt, name)
  final = FINAL.dup
  json = JSON.dup
  action = ACTION.dup

  final.gsub!(/OUTPUT/, "DICE")
  action.gsub!(/ACTION_NAME/, name)
  json.gsub!(/TYPE/, "damage")
  json.gsub!(/OTHER/, "," + action)
  final.gsub!(/JSON/, json)

  txt.gsub!(/(\d+d\d+( ?[-\+] ?\d+)?)/) do |s|
    s = final.gsub(/DICE/, s.downcase.gsub(/\s/, ""))
  end

  return txt
end

# Option #2 - Traits
def attributes
  traits = []
  foo = ""

  spellcasting = spellcasting()
  if !spellcasting.empty?
    # Add spellcasting trait
    traits.push(spellcasting)

    # Check if continue
    puts "Spellcasting added, continue? (Y/n)"
    foo = gets.strip.downcase
    puts ""
  else
    puts "Spellcasting skiped, first trait..."
    puts ""
  end

  # Loop to get several traits
  while foo != "n"
    # Open paragraph tag
    trait = "<p>"
    # Get trait name (surrounded by bold tags)
    puts "Name of the trait:"
    name = gets.strip
    trait << "<strong>" + name + ".</strong> "
    puts ""
    # Get trait text
    puts "Text of the trait:"
    text = gets_clipboard()
    # Check for dice rolls
    if /\d+d\d+([-\+]\d+)?/.match?(text)
      puts "Your text contains dice rolls, process them? (Y/n)"
      if gets.strip.downcase != "n"
        text = process_dmg_rolls(text, name)
      end
    end
    trait << text
    puts ""
    # Close paragraph
    trait << "</p>"

    # Show final trait
    puts "Final trait:"
    puts trait
    puts ""

    # Inject into array
    traits.push(trait)
    # Check to add another
    puts "Add another? (Y/n)"
    foo = gets.strip.downcase
    puts ""
  end

  # Once all traits added, check how many
  if traits.length > 0
    # Show total number
    puts "Total of " + traits.length.to_s + " trait(s)."
    # Compile final string
    final = traits.join("\n")
    # Copy final string to clipboard
    Clipboard.copy(final)
    puts "Copied to clipboard!"
  end
end
# Sub-method - Process spellcasting
def spellcasting
  spellcasting = []

  # Check if creature will have spellcasting
  puts "Will the creature have spellcasting? (y/N)"
  if gets.strip.downcase == "y"
    puts ""
    title = "<p><strong>"
    # Get trait title
    puts "What will be the spellcasting title?"
    puts "  1. Spellcasting (default);"
    puts "  2. Innate Spellcasting; or"
    puts "  3. Other."
    case gets.to_i
    when 2
      spell_name = "Innate Spellcasting"
    when 3
      puts "Enter spellcasting title:"
      spell_name = gets.strip
    else
      spell_name = "Spellcasting"
    end
    title << spell_name + ".</strong> "
    # Get trait intro text
    puts "What will be the spellcasting intro text?"
    spell_text = gets_clipboard()
    # Check for dice rolls
    if /[-\+]\d+/.match?(spell_text)
      puts "Your text contains dice rolls, process them? (Y/n)"
      if gets.strip.downcase != "n"
        spell_text = process_atk_rolls(spell_text, spell_name)
      end
    end
    title << spell_text
    # Insert into array
    spellcasting.push(title)

    # Get spellcasting economy style
    puts "What kind of economy will the creature use?"
    puts "  1. Spellslots (default);"
    puts "  2. Times per day; or"
    puts "  3. Times per period."
    case gets.to_i
    when 2
      spellcasting.concat(spells_per_day())
    when 3
      spellcasting.concat(spells_per_period())
    else
      spellcasting.concat(spells_per_slot())
    end

    # Close paragraph
    spellcasting.push("</p>")
  end
  puts ""

  return spellcasting.join("<br>\n")
end
# Sub-method - Process (spell) attack rolls
def process_atk_rolls(txt, name)
  final = FINAL.dup
  json = JSON.dup
  action = ACTION.dup

  final.gsub!(/OUTPUT/, "DICE")
  action.gsub!(/ACTION_NAME/, name)
  json.gsub!(/TYPE/, "to hit")
  json.gsub!(/OTHER/, "," + action)
  final.gsub!(/JSON/, json)

  txt.gsub!(/([-\+]\d+)/) do |s|
    s = s.to_i
    sign = s < 0 ? "-" : "+"
    s = final.gsub(/DICE/, "1d20" + sign + s.abs.to_s)
  end

  return txt
end
# Sub-method - Get spells by spell slot
def spells_per_slot
  spells = []
  level = 0
  foo = ""

  # Get spells by each level of slot
  while level < 10 && foo != "n"
    text = ""
    slots = nil
    level_txt = ""

    # Set subtitle
    case level
    when 0
      text << "Cantrips "
      level_txt = "cantrips"
    when 1
      text << "1st level "
      level_txt = "1st level spells"
    when 2
      text << "2nd level "
      level_txt = "2nd level spells"
    when 3
      text << "3rd level "
      level_txt = "3rd level spells"
    else
      text << level.to_s + "th level "
      level_txt = level.to_s + "th level spells"
    end
    puts "Setting " + level_txt + "..."
    # Get number of slots
    if level != 0
      puts "How many slots?"
      slots = gets.to_i
      puts ""
    end
    if slots.nil?
      text << "(at will)"
    else
      text << "(" + slots.to_s + " slot" + (slots > 1 ? "s" : "") + ")"
    end
    text << ": "

    # Get spell list for level
    puts "What are the " + level_txt + "?"
    text << process_spell_list()

    # Add to array
    spells.push(text)

    # Check to continue
    level += 1
    if level < 10
      puts "Continue to next level? (Y/n)"
      foo = gets.strip.downcase
    end
  end

  # Return retrieved spells
  return spells
end
# Sub-method - Get spells per day
def spells_per_day
  spells = []
  foo = ""

  # Get spells by frequency
  while foo != "n"
    text = ""

    # Get times per day
    puts "How many times per day? (0 = at will)"
    freq = gets.to_i
    if freq == 0
      text << "At will"
    else
      text << freq.to_s + "/day"
    end
    text << ": "

    # Get spell list for frequency
    puts "What are the spells?"
    text << process_spell_list()

    # Add to array
    spells.push(text)

    # Check to continue
    puts "Continue to more frequencies? (Y/n)"
    foo = gets.strip.downcase
  end

  # Return retrieved spells
  return spells
end
# Sub-method - Get spells per period
def spells_per_period
  spells = []
  foo = ""

  # Get spells by frequency
  while foo != "n"
    text = ""

    # Get times per day
    puts "How many times per period? (0 = at will)"
    freq = gets.to_i
    if freq == 0
      text << "At will"
    else
      text << freq.to_s + "/"
    end
    # Get period
    if freq > 0
      puts "What is the frequency? (per/X)"
      puts "  1. Rest (default)"
      puts "  2. Short Rest"
      puts "  3. Long Rest"
      puts "  4. Week"
      puts "  5. Month"
      puts "  6. Year"
      case gets.to_i
      when 2
        text << "short rest"
      when 3
        text << "long rest"
      when 4
        text << "week"
      when 5
        text << "month"
      when 6
        text << "year"
      else
        text << "rest"
      end
    end
    text << ": "

    # Get spell list for frequency
    puts "What are the spells?"
    text << process_spell_list()

    # Add to array
    spells.push(text)

    # Check to continue
    puts "Continue to more frequencies? (Y/n)"
    foo = gets.strip.downcase
  end

  # Return retrieved spells
  return spells
end
# Sub-method - Process spell list
def process_spell_list
  spell_list = gets_clipboard()
  spell_list = spell_list.split(",")
  spell_list.map! do |x|
    spell = x.strip
    if spell.include? "("
      spell = spell.split("(")
      spell[0] = "[spell]" + spell[0].strip + "[/spell]"
      spell[1] = "(" + spell[1]
      spell = spell.join(" ")
    else
      spell = "[spell]" + spell + "[/spell]"
    end
    x = spell
  end
  return spell_list.join(", ")
end

# Option #3 - Legendary Actions
def legendary_actions
  actions = []
  intro = "The NAME can take COUNT legendary actions, choosing from the options below. Only one legendary action can be used at a time and only at the end of another creature's turn. The NAME regains spent legendary actions at the start of PRONOUN turn."
  foo = ""

  # Get intro text
  puts "What name to use in the Legendary Actions intro text?"
  name = gets.strip
  puts "What pronoun to use for '#{name}'?"
  puts "  1. She/Her"
  puts "  2. He/Him"
  puts "  3. They/Them"
  puts "  4. It/Its (default)"
  index = gets.to_i
  case index
  when 1
    pronoun = "her"
  when 2
    pronoun = "his"
  when 3
    pronoun = "their"
  else
    pronoun = "its"
  end
  puts "How many actions can '#{name}' take? (Default = 3)"
  count = gets.strip
  count = count.empty? ? 3 : count.to_i
  # Compile intro
  intro.gsub!(/NAME/, name)
  intro.gsub!(/PRONOUN/, pronoun)
  intro.gsub!(/COUNT/, count.to_s)
  actions.push("<p>" + intro + "</p>")

  # Loop to get several actions
  while foo != "n"
    # Open paragraph tag
    action = "<p>"
    # Get leg. action name (surrounded by bold tags)
    puts "Name of the legendary action:"
    act_name = gets.strip
    action << "<strong>" + act_name + ".</strong> "
    puts ""
    # Get leg. action text
    puts "Text of the legendary action:"
    text = gets_clipboard()
    # Check for dice rolls
    if /\d+d\d+([-\+]\d+)?/.match?(text)
      puts "Your text contains dice rolls, process them? (Y/n)"
      if gets.strip.downcase != "n"
        text = process_dmg_rolls(text, act_name)
      end
    end
    action << text
    # Close paragraph
    action << "</p>"

    # Show final leg. action
    puts "Final legendary action:"
    puts action
    puts ""

    # Inject into array
    actions.push(action)
    # Check to add another
    puts "Add another? (Y/n)"
    foo = gets.strip.downcase
    puts ""
  end

  # Once all leg. actions added, check how many
  if actions.length > 1
    # Show total number
    puts "Total of " + (actions.length - 1).to_s + " action(s), plus intro."
    # Compile final string
    final = actions.join("\n")
    # Copy final string to clipboard
    Clipboard.copy(final)
    puts "Copied to clipboard!"
  end
end

# Get contents from user, first checking for
# clipboard contents.
def gets_clipboard
  # Get contents of the Clipboard
  ctrl_v = Clipboard.paste.encode('UTF-8').to_s.strip
  # Check if empty
  if !ctrl_v.empty?
    # If NOT empty, check if use it
    puts "Use copied text? (Y/n)"
    if gets.strip.downcase != "n"
      return ctrl_v
    else
      puts "Enter text:"
      return gets.strip
    end
  else
    # If EMPTY, get text
    return gets.strip
  end
end