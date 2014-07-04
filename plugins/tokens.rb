#!/usr/bin/env ruby

require 'set'

module Dataknife
  module Plugins
    class TokensPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Returns all whitespace-delimited tokens in input"
        @syntax = "tokens [u]"
        @command = "tokens"
      end

      def main(args)
        unique = args.length == 1 and args[0] == 'u'
        set = Set.new
        STDIN.each_line do |line|
          line.split(/\s+/).each do |token|
            if token !~ /^\s*$/
              if unique
                set.add token 
              else
                puts token
              end
            end
          end
        end
        set.each {|i| puts i} if unique
      end
    end

    TokensPlugin.new
  end
end


