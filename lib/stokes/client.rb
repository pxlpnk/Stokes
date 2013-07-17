require 'blather/client/dsl'

module Stokes

  def self.say(client, from, message)
    client.write Blather::Stanza::Message.new(from, message, :chat)
  end

  class Client
    include Blather::DSL

    LOGGER = Logger.new(STDOUT)
    LOGGER.level = Logger::DEBUG


    def run(plugins)


      setup ENV['JID'], ENV['JPASSWORD']

      LOGGER.info "Connecting..."

      master = ENV['master']

      subscription :request? do |s|
        write_to_stream s.approve!
      end

      when_ready do
        LOGGER.info "Connected"
        Stokes.say client, master, "Reporting for duty master!"
      end

      before(:message) do |m|
        unless m.body.nil?
          unless (m.from.stripped == master)
            say m.from ,"Not authorized"
            LOGGER.info "Not authorized message from: #{m.from}"
            halt
          else
            LOGGER.info "Authorized message from: #{m.from} - #{m.body}"
          end
        end
      end

      message :chat?, :body => /^echo\s/ do |m|
        m.body =~ /^echo\s(.*)/
        say m.from, $1
      end

      message :chat?, :body => /^h|^help/ do |m|
        usage = plugins.inject([]){ |accu, plugin| accu << plugin.help}.flatten.join "\n"
        say m.from, usage
      end

      #reconnect!
      disconnected { client.connect }


      message :chat?, :body => 'exit' do |m|
        LOGGER.info "Shutting down!"
        say m.from, 'Exiting ...'
        sleep 0.5
        shutdown
      end


      plugins.each do |plugin|
        LOGGER.info "Register plugin: #{plugin}"
        plugin.register client
      end

      client.run

    end
  end
end
