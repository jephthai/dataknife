#!/usr/bin/env ruby

module Dataknife
  module Plugins
    class MeanPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Tokenizes the input and calculates the numeric mean"
        @syntax = "mean"
        @command = "mean"
      end

      def main(args)
        count = 0
        total = 0.0
        STDIN.each_line do |line|
          line.split(/\s+/).each do |token|
            unless token =~ /^\s*$/
              count += 1
              total += token.to_f
            end
          end
        end
        puts total / count
      end
    end

    MeanPlugin.new
  end
end

