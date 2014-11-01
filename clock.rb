require 'clockwork'

module Clockwork
  every(1.day, 'backup.job') {
    `bundle exec ruby entry.rb`
  }
end