#!/usr/bin/env ruby

require 'base64'

module Dataknife
  module Plugins
    class Base64Plugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Base64 decodes input (encode if 'e' parameter provided)"
        @syntax = "base64 [(e|d)]"
        @command = "base64"
      end

      def main(args)
        if args.length == 1 and args[0] == "e"
          print Base64::encode64(STDIN.read)
        else
          print Base64::decode64(STDIN.read)
        end
      end
    end

    Base64Plugin.new
  end
end


