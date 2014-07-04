#!/usr/bin/env ruby

require 'set'

module Dataknife
  module Plugins
    class UnbinPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Remove non-printable characters from the input"
        @syntax = "unbin [.]"
        @command = "unbin"
      end

      def main(args)
        dot = args.length == 1 and args[0] == "."
        begin
          while block = STDIN.sysread(1024)
            block.each_byte do |b|
              if (' '..'~').cover? b.chr
                print b.chr
              else
                print '.' if dot
              end
            end
          end
        rescue EOFError
        end
      end
    end

    UnbinPlugin.new
  end
end


