$LOAD_PATH << './lib'
require 'rubygems'
require 'stokes'

$stdout.sync = true

EM.run do
  Stokes.run!
end
