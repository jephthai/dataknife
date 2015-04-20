#!/usr/bin/env ruby

require 'open-uri'

module Dataknife
  module Plugins
    class URLEncodePlugin < Dataknife::Plugins::DefaultPlugin

      def initialize
        super
        @help = "URL-decodes input ('e'=encode, 'd'=decode)"
        @syntax = "urlencode (e|d)"
        @command = "urlencode"
      end

      def main(args)
        if args.length == 1 and args[0] == "d"
          print URI::decode(STDIN.read.strip)
        else
          print URI::encode(STDIN.read.strip)
        end
      end
    end

    URLEncodePlugin.new
  end
end


