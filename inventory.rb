require 'nokogiri'
require 'net/http'
require './item.rb'

class Inventory
  attr_reader :weapons, :mods, :characters, :consumables, :gears

  def initialize(url)
    doc = Nokogiri::HTML(Net::HTTP.get(URI.parse(url)))
    inventory = doc.css('div#inventory div#inventory_content')
    @weapons = inventory.css('div#weapons_content div.card').map{|v|Item.new(:weapon, v)}
    @mods = inventory.css('div#weapon_mods_content div.card').map{|v|Item.new(:mod, v)}
    @characters = inventory.css('div#inventory_characters_content div.card').map{|v|Item.new(:character, v)}
    @consumables = inventory.css('div#consumables_content div.card').map{|v|Item.new(:consumable, v)}
    @gears = inventory.css('div#gear_content div.card').map{|v|Item.new(:gear, v)}
  end

  def print
    print_weapons
    print_mods
    print_characters
    print_consumables
    print_gears
  end

private
  def print_weapons
    print_weapons_common
    print_weapons_uncommon
    print_weapons_rare
    print_weapons_ultrarare
  end

  def print_weapons_common
    puts "Weapon - Common"
    weapons.select{ |item| item.rarity == 'common' }.each{ |item| puts item.level }
  end

  def print_weapons_uncommon
    puts "Weapon - Uncommon"
    weapons.select{ |item| item.rarity == 'uncommon' }.each{ |item| puts item.level }
  end

  def print_weapons_rare
    puts "Weapon - Rare"
    weapons.select{ |item| item.rarity == 'rare' }.each{ |item| puts item.level }
  end

  def print_weapons_ultrarare
    puts "Weapon - Ultrarare"
    weapons.select{ |item| item.rarity == 'ultrarare' }.each{ |item| puts item.level }
  end

  def print_mods
    print_mods_common
    print_mods_uncommon
    print_mods_rare
  end

  def print_mods_common
    puts "Mods - Common"
    mods.select{ |item| item.rarity == 'common' }.each{ |item| puts item.level }
  end

  def print_mods_uncommon
    puts "Mods - Uncommon"
    mods.select{ |item| item.rarity == 'uncommon' }.each{ |item| puts item.level }
  end

  def print_mods_rare
    puts "Mods - Rare"
    mods.select{ |item| item.rarity == 'rare' }.each{ |item| puts item.level }
  end

  def print_characters
    print_characters_common
    print_characters_uncommon
    print_characters_rare
    print_characters_ultrarare
  end

  def print_characters_common
    puts "Character - Common"
    characters.select{ |item| item.rarity == 'common' }.each{ |item| puts item.level }
  end

  def print_characters_uncommon
    puts "Character - Uncommon"
    characters.select{ |item| item.rarity == 'uncommon' }.each{ |item| puts item.level }
  end

  def print_characters_rare
    puts "Character - Rare"
    characters.select{ |item| item.rarity == 'rare' }.each{ |item| puts item.level }
  end

  def print_characters_ultrarare
    puts "Character - Ultrarare"
    characters.select{ |item| item.rarity == 'ultrarare' }.each{ |item| puts item.level }
  end

  def print_consumables
    puts "Consumables"
    consumables.select do |item|
      case item.name
      when 'Thermal Clip Pack', 'Medi-Gel', 'Cobra Missile Launcher', 'Ops Survival Pack'
        true
      else
        false
      end
    end.each { |item| puts item.level }
  end

  def print_gears
    print_gears_uncommon
    print_gears_rare
  end

  def print_gears_uncommon
    puts "Gears - Uncommon"
    gears.select{ |item| item.rarity == 'uncommon' }.each{ |item| puts item.level }
  end

  def print_gears_rare
    puts "Gears - Rare"
    gears.select{ |item| item.rarity == 'rare' }.each{ |item| puts item.level }
  end
end
