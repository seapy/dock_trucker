# !/usr/bin/env ruby

load_path = File.expand_path('lib')
$LOAD_PATH.unshift(load_path)

require 'active_support/core_ext/string'
require 'dock_trucker'

store_name = ARGV[0]
store = "dock_trucker/store/#{store_name}".downcase.classify.constantize.new
client = DockTrucker::Client.new(store: store)
client.backup
client.vacuum
client.sync
