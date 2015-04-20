#!/usr/bin/env ruby

require 'set'

module Dataknife
  module Plugins
    class URLifyPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Convert inputs to URLs"
        @syntax = "urls"
        @command = "urls"
      end

      def main(args)
        proto = "http"
        port = nil
        infile = STDIN
        if args.length >= 1
          args.each do |arg|
            case arg
            when 'd'
              unique = true
            when /^[0-9]+$/
              port = arg
            else
              if File.exists? arg
                infile = open(arg)
              else
                proto = arg
              end
            end
          end
        end

        set = Set.new
        infile.each_line do |line|
          pspec = port ? ":#{port}" : ""
          puts "#{proto}://#{line.strip}#{pspec}/"
        end
      end
    end

    URLifyPlugin.new
  end
end


