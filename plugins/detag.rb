#!/usr/bin/env ruby

require 'set'

module Dataknife
  module Plugins
    class DetagPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Remove XML/HTML tags from the input"
        @syntax = "detag"
        @command = "detag"
      end

      def main(args)
        STDIN.each_line do |line|
          puts line.gsub(/<.*?>/, "")
        end
      end
    end

    DetagPlugin.new
  end
end


