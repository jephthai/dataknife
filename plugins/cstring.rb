#!/usr/bin/env ruby

require 'set'

module Dataknife
  module Plugins
    class CStringPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Output as a literal C-String"
        @syntax = "cstring"
        @command = "cstring"
      end

      def main(args)
        dot = args.length == 1 and args[0] == "."
        begin
          while block = STDIN.sysread(1024)
            block.each_byte do |b|
              # if (' '..'~').cover? b.chr
              #   print b.chr
              # else
                printf("\\x%02x", b)
              # end
            end
          end
        rescue EOFError
        end
        puts
      end
    end

    CStringPlugin.new
  end
end


