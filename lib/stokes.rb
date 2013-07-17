require 'stokes/client'

# require all plugins at startup
Dir[File.dirname(__FILE__) + "/plugins/*.rb"].each {|file| require file;}


module Stokes
  PLUGINS = [
    Stokes::GoogleSearch,
    Stokes::RandomKitty,
    Stokes::TrueRandom,
    Stokes::UpDown,
    Stokes::HttpMonitor
  ]


  def self.run!
    EM.run do
      stokes = Client.new
      stokes.run PLUGINS
    end
  end
end

trap(:INT) { EM.stop }
trap(:TERM) { EM.stop }
