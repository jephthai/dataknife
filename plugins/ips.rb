#!/usr/bin/env ruby

require 'set'

module Dataknife
  module Plugins
    class IPsPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Print all IP addresses detected in the input"
        @syntax = "ips"
        @command = "ips"
      end

      def main(args)
        unique = args.length == 1 and args[0] == 'd'
        set = Set.new
        STDIN.each_line do |line|
          line.scan(/\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/).each do |ip|
            if ip.split(/\./).all? 
              if unique
                set.add ip
              else
                puts ip
              end
            end
          end
        end
        set.each {|i| puts i} if unique
      end
    end

    IPsPlugin.new
  end
end


