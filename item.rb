
ITEM_CLASS = /multiplayer\/cards\/(common|uncommon|rare|ultrarare)-(on|off).png/
ITEM_LEVEL = /multiplayer\/levels\/(\d+)-(\d+).png/
CONSUMABLE_COUNT = /(.*) - (\d+)/

class Item
  attr_reader :type, :name, :level, :max_level, :active, :description, :rarity

  def initialize(type, raw)
    @type = type
    @name = raw.css('span').first.content

    if match = raw['style'].match(ITEM_CLASS)
      @rarity, @active = match.captures
      @active = @active == 'on'
    end

    @description = raw.css('img').first['title']

    if match = raw.css('img').last['src'].match(ITEM_LEVEL)
      @max_level, @level = match.captures.map(&:to_i)
    end

    if type == :consumable
      @name, @level = @name.match(CONSUMABLE_COUNT).captures
      @max_level = consumable_max_level(@name)
    end

    # if type == :mod
    #   @rarity = mod_rarity(name)
    # end
  end

  def to_s
    "#{type}:\t#{name}:\t#{rarity} (#{active})\t- #{level}/#{max_level}"
  end

private
  def consumable_max_level(name)
    case name
    when 'Thermal Clip Capacity', 'Medi-Gel Capacity', 'Cobra Missile Launcher Capacity', 'Ops Survival Pack Capacity'
      6
    when 'Reset Powers'
      3
    else
      255
    end
  end

  # Apparently the mod rarity is different in the pack than in game
  def mod_rarity(name)
    case name
    when /Assault Rifle Stability Damper/,
      /Pistol Scope/,
      /SMG Magazine Upgrade/,
      /Shotgun Smart Choke/,
      /Sniper Rifle Spare Thermal Clip/
      'common'
    when /Assault Rifle Precision Scope/,
      /Assault Rifle Magazine Upgrade/,
      /Shotgun High Caliber Barrel/,
      /Shotgun Blade Attachment/,
      /Pistol High-Caliber Barrel/,
      /Pistol Magazine Upgrade/,
      /SMG Scope/,
      /SMG Heat Sink/,
      /Sniper Rifle Extended Barrel/
      'uncommon'
    else
      'rare'
    end
  end
end
