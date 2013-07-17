module Stokes
  module UpDown
    class << self
      def register(client)
        client.register_handler :message, :chat?, :body => /^up\? / do |m|
          response = get(m.body.match(/^up\?\s(.*)/)[1].to_s)
          Stokes.say client, m.from, response
        end
      end

      def get(uri)
        begin
          url = URI::parse uri
          response = Net::HTTP.get_response(url)
          headers = response.to_hash.inject([]){|c,(k,v)| c << [k,v].join(':')}
          formated_headers = headers.join "\n"
          "#{response.code} - #{response.message} \n Headers: #{formated_headers}"
          rescue URI::InvalidURIError => e
            e.message
          rescue SocketError => e
          e.message
        end
      end

      def help
        "up? <http://example.com>: prints the status and the headers of a request to the target"
      end
    end #Class
  end #UpDown
end #Stokes
