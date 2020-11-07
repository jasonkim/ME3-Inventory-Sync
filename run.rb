#! /usr/bin/env ruby

require './inventory.rb'
require './google_sync.rb'
require 'json'

urls = JSON.parse(open("./urls.json").read)

inventory = Inventory.new(urls['profile'])
# inventory.print

sync = GoogleSync.new(urls['sheet'])
puts sync.update(inventory)
