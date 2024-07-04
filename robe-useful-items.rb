def patch(index)
  case index
  when 1..8
    return "Bag of 100 gp"
  when 9..15
    return "Silver coffer (1 foot long, 6 inches wide and deep) worth 500 gp"
  when 16..22
    return "Iron door (up to 10 feet wide and 10 feet high, barred on one side of your choice), which you can place in an opening you can reach; it conforms to fit the opening, attaching and hinging itself"
  when 23..30
    return "10 gems worth 100 gp each"
  when 31..44
    return "Wooden ladder (24 feet long)"
  when 45..51
    return "A riding horse with saddle bags"
  when 52..59
    return "Pit (a cube 10 feet on a side), which you can place on the ground within 10 feet of you"
  when 60..68
    return "Potion of healing (4)"
  when 69..75
    return "Rowboat (12 feet long)"
  when 76..83
    return "Spell scroll of "
  when 84..90
    return "Mastiff (2)"
  when 91..96
    return "Window (2 feet by 4 feet, up to 2 feet deep), which you can place on a vertical surface you can reach"
  when 97..100
    return "Portable ram"
  else
    return "A poof of smoke"
  end
end

def spell
  spells = ["Aid", "Alarm", "Alter Self", "Animal Friendship", "Animal Messenger", "Animate Dead", "Arcane Lock", "Armor of Agathys", "Arms of Hadar", "Augury", "Aura of Vitality", "Bane", "Barkskin", "Beacon of Hope", "Beast Sense", "Bestow Curse", "Bless", "Blinding Smite", "Blindness/Deafness", "Blink", "Blur", "Branding Smite", "Burning Hands", "Call Lightning", "Calm Emotions", "Charm Person", "Chromatic Orb", "Clairvoyance", "Cloud of Daggers", "Color Spray", "Command", "Compelled Duel", "Comprehend Languages", "Conjure Animals", "Conjure Barrage", "Continual Flame", "Cordon of Arrows", "Counterspell", "Create Food and Water", "Create or Destroy Water", "Crown of Madness", "Crusader's Mantle", "Cure Wounds", "Darkness", "Darkvision", "Daylight", "Detect Evil and Good", "Detect Magic", "Detect Poison and Disease", "Detect Thoughts", "Disguise Self", "Dispel Magic", "Dissonant Whispers", "Divine Favor", "Elemental Weapon", "Enhance Ability", "Enlarge/Reduce", "Ensnaring Strike", "Entangle", "Enthrall", "Expeditious Retreat", "Faerie Fire", "False Life", "Fear", "Feather Fall", "Feign Death", "Find Familiar", "Find Steed", "Find Traps", "Fireball", "Flame Blade", "Flaming Sphere", "Fly", "Fog Cloud", "Gaseous Form", "Gentle Repose", "Glyph of Warding", "Goodberry", "Grease", "Guiding Bolt", "Gust of Wind", "Hail of Thorns", "Haste", "Healing Word", "Heat Metal", "Hellish Rebuke", "Heroism", "Hex", "Hold Person", "Hunger of Hadar", "Hunter's Mark", "Hypnotic Pattern", "Identify", "Illusory Script", "Inflict Wounds", "Invisibility", "Jump", "Knock", "Leomund's Tiny Hut", "Lesser Restoration", "Levitate", "Lightning Arrow", "Lightning Bolt", "Locate Animals or Plants", "Locate Object", "Longstrider", "Mage Armor", "Magic Circle", "Magic Missile", "Magic Mouth", "Magic Weapon", "Major Image", "Mass Healing Word", "Meld into Stone", "Melf's Acid Arrow", "Mirror Image", "Misty Step", "Moonbeam", "Nondetection", "Nystul's Magic Aura", "Pass without Trace", "Phantasmal Force", "Phantom Steed", "Plant Growth", "Prayer of Healing", "Protection from Energy", "Protection from Evil and Good", "Protection from Poison", "Purify Food and Drink", "Ray of Enfeeblement", "Ray of Sickness", "Remove Curse", "Revivify", "Rope Trick", "Sanctuary", "Scorching Ray", "Searing Smite", "See Invisibility", "Sending", "Shatter", "Shield", "Shield of Faith", "Silence", "Silent Image", "Sleep", "Sleet Storm", "Slow", "Speak with Animals", "Speak with Dead", "Speak with Plants", "Spider Climb", "Spike Growth", "Spirit Guardians", "Spiritual Weapon", "Stinking Cloud", "Suggestion", "Tasha's Hideous Laughter", "Tenser's Floating Disk", "Thunderous Smite", "Thunderwave", "Tongues", "Unseen Servant", "Vampiric Touch", "Warding Bond", "Water Breathing", "Water Walk", "Web", "Wind Wall", "Witch Bolt", "Wrathful Smite", "Zone of Truth"]
  return spells[ rand(0..(spells.length-1)) ]
end

def gem
  gems = ["Amber", "Amethyst", "Chrysoberyl", "Coral", "Garnet", "Jade", "Jet", "Pearl", "Spinel", "Tourmaline"]
  return gems[ rand(0..(gems.length-1)) ]
end

def robe_useful_items
  puts "#######################################"
  puts "#    Robe of Useful Items Generator   #"
  puts "#######################################"
  puts ""

  count = 0
  for i in 1..4
    count += rand(1..4)
  end
  puts "# The robe contains #{count} items:"

  for k in 1..count
    i = rand(1..100)
    item = patch(i)
    scroll = ""
    if i.between?(76, 83)
      scroll = spell
    end
    if i.between?(23, 30)
      sack = []
      item = []
      for i in 1..10
        sack.push(gem)
      end
      sack.tally.each do |key, value|
        item.push( "#{key} (#{value})" )
      end
      item = "A pouch containing: " + item.sort.join(", ")
    end
    puts "#{k}: #{item}#{scroll}"
  end
end
