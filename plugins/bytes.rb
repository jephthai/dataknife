#!/usr/bin/env ruby

module Dataknife
  module Plugins
    class BytesPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Counts bytes in data blob"
        @syntax = "bytes"
        @command = "bytes"
      end

      def main(args)
        count = 0
        begin
          while(input = STDIN.sysread(1024))
            count += input.length
          end
        rescue EOFError
        end
        puts "Read #{count} bytes."
      end
    end

    BytesPlugin.new
  end
end


