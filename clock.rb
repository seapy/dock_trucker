require 'clockwork'

module Clockwork
  every(1.day, 'backup.job') {
    `./run.sh #{ENV['STORE_NAME']}`
  }
end
