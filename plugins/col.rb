#!/usr/bin/env ruby

require 'set'

module Dataknife
  module Plugins
    class ColPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Print indicated column(s) from input lines"
        @syntax = "col C1 [C2] ..."
        @command = "col"
      end

      def main(args)
        if args.length < 1 or args.any? {|i| i.to_i == 0}
          print "ERROR: provide positive column numbers to print"
        else
          columns = args.map {|i| i.to_i - 1}
          STDIN.each_line do |line|
            fields = line.split
            columns.each do |column|
              print fields[column] + " " if fields.length >= column
            end
            puts
          end
        end
      end
    end

    ColPlugin.new
  end
end


