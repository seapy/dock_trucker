# !/usr/bin/env ruby

load_path = File.expand_path('lib')
$LOAD_PATH.unshift(load_path)

require 'dock_trucker'
store_name =  ARGV[0]
puts store_name

store = DockTrucker::Store::S3.new
client = DockTrucker::Client.new(store: store)
client.backup
client.vacuum
client.sync
