#!/usr/bin/env ruby

require 'set'

module Dataknife
  module Plugins
    class DesymPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Remove any non-alphabetic symbols from the input"
        @syntax = "desym"
        @command = "desym"
      end

      def main(args)
        STDIN.each_line do |line|
          puts line.gsub(/[^a-z^A-Z^\d^\s]+/, " ")
        end
      end
    end

    DesymPlugin.new
  end
end


