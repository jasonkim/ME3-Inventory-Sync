#! /usr/bin/env ruby

require './inventory.rb'
require './google_sync.rb'
require 'json'

urls = JSON.parse(ENV['urls'] || open("./urls.json").read)
credential = ENV['CREDENTIAL']

urls.each do |url|
  inventory = Inventory.new(url['profile'])
  # inventory.print

  sync = GoogleSync.new(url['sheet'], credential)
  puts sync.update(inventory).to_json
end
