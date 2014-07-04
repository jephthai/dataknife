#!/usr/bin/env ruby

module Dataknife
  module Plugins
    class LinesPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Counts lines in data blob"
        @syntax = "lines"
        @command = "lines"
      end

      def main(args)
        count = 0
        STDIN.each_line do |line|
          count += 1
        end
        puts "Read #{count} lines."
      end
    end

    LinesPlugin.new
  end
end


