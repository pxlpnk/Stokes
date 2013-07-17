require 'net/http'
require "rexml/document"


module Stokes
  module RandomKitty
    class << self
      include REXML

      def register(client)
        client.register_handler :message, :chat?, :body => /^k/ do |m|
          Stokes.say client, m.from, get_cat
        end
      end

      def help
        "k: presents you with a cute kitty!"
      end

      def get_cat
        url = 'http://thecatapi.com/api/images/get?format=xml&results_per_page=1'
        begin
          xml = Net::HTTP.get(URI.parse(url))
          doc = REXML::Document.new(xml)
          return XPath.first(doc, '//source_url').text
        rescue Net::HTTPError => e
          return "Could not show you a Kitty: #{URL}"
        end
      end
    end # class
  end #RandomKitty
end #Stock
