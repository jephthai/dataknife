#!/usr/bin/env ruby

module Dataknife
  module Plugins
    class HexPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "HEX encoded input ('e'=encode, 'd'=decode)"
        @syntax = "hex (e|d)"
        @command = "hex"
      end

      def main(args)
        if args.length == 1 and args[0] == "d"
          print [STDIN.read.strip].pack("H*")
        else
          print STDIN.read.unpack("H*")[0]
        end
      end
    end

    HexPlugin.new
  end
end

