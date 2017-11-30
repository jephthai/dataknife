#!/usr/bin/env ruby

require 'Ascii85'

module Dataknife
  module Plugins
    class A85Plugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "ASCII85 decodes input (encode if 'e' parameter provided)"
        @syntax = "a85 [(e|d)]"
        @command = "a85"
      end

      def main(args)
        if args.length == 1 and args[0] == "e"
          print Ascii85::encode(STDIN.read)
        else
          print Ascii85::decode(STDIN.read)
        end
      end
    end

    A85Plugin.new
  end
end


