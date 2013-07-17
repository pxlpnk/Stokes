require 'google-search'

module Stokes
  module GoogleSearch
    class << self

      def register(client)
        client.register_handler :message, :chat?, :body => /^g\s/ do |m|
          m.body =~ /^g\s(.*)/
          result = search $1
          Stokes.say client, m.from, result
        end
      end

      def help
        "g <query>: returns the first 4 results for the query"
      end

      private
      def search(query)
        search = Google::Search::Web.new(:query => query, :size => :small)
        result_set = search.all_items[0..4]
        result = result_set.inject("") {|accu, r| accu << "#{r.title} - #{r.uri}\n"}

        result
      end
    end #class
  end #Google
end #Stokes
