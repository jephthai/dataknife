#!/usr/bin/env ruby

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
	require 'ascii85'

        data = STDIN.read
        data = "<~" + data unless data.start_with?("<~")
        data = data + "~>" unless data.end_with?("<~") 

        if args.length == 1 and args[0] == "e"
          print Ascii85::encode(data)
        else
          print Ascii85::decode(data)
        end
      end
    end

    A85Plugin.new
  end
end


