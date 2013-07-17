module Stokes
  module TrueRandom
    class << self

      def register(client)
        client.register_handler :message, :chat?, :body => /^trpw/ do |m|

          response = case (n = m.body.match(/^trpw\s?([0-9]{0,2})$/)[1].to_i)
                     when 0
                       get_random_password(13).join("\n")
                     when 6..24
                       get_random_password(n).join("\n")
                     else
                       "Length needs to be in the interval  [6,24]"
                     end
          Stokes.say client, m.from, response
        end

        client.register_handler :message, :chat?, :body => "trquota" do |m|
          Stokes.say client, m.from, get_bits
        end
      end

      def help
        [
          "trpw <length>: returns 3 password with the specified length. (default: 10)",
          "trquota: returns the left over bit quota"
        ]
      end

      private

      def get_bits
        url = "http://www.random.org/quota/?format=plain"
        get(url).first
      end


      def get_random_password(n)
        url = "https://www.random.org/passwords/?num=3&len=#{n}&format=plain&rnd=new"
        get url
      end


      def get(url)
        begin
          return Net::HTTP.get(URI.parse(url)).split
        rescue Error => e
          return "Could not get you a password#{e}"
        end
      end

    end #class
  end #TrueRandom
end #Stokes
