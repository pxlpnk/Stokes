require 'redis'

module Stokes
  module HttpMonitor
    @monitor = nil
    REDIS = nil
    class << self

      REDIS = Redis.new

      def register(client)
        client.register_handler :message, :chat?, :body => /^m\s/ do |m|
          REDIS.lpush "hosts", m.body
          Stokes.say client, m.from, m
        end

        client.register_handler :message, :chat?, :body => "m!" do |m|
          Stokes.say client, m.from, REDIS.lrange('hosts', 0, -1).to_s
        end

        @monitor = Monitor.new
        Monitor.run client, REDIS
      end

      def help
        "m add <host>: adds a basic http request monitoring"
        "m del <host>: removes host from the monitoring"
        "m!: shows hosts under moinitoring"
      end
    end

    class Monitor
#      include EM::Deferrable

      def self.run(client, redis)
        EM.add_timer(3) do
          Stokes.say client, "at@an-ti.eu", "I am Monitoring for you!"
        end

        EM.run do
          EM::PeriodicTimer.new(5) do
            host = redis.lpop "hosts"
            redis.rpush "hosts", host

            Stokes.say client, "at@an-ti.eu", redis.lrange('hosts', 0, -1).to_s
          end
        end
      end
    end
  end
end
