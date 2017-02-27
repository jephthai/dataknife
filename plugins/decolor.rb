#!/usr/bin/env ruby

module Dataknife
  module Plugins
    class DecolorPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Remove ANSI color sequences from input"
        @syntax = "decolor"
        @command = "decolor"
      end

      def main(args)
        infile = args.length > 0 ? args[0] : STDIN
        infile.each_line do |line|
          puts line.gsub(/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]/, "")
        end
      end
    end

    DecolorPlugin.new
  end
end


