#!/usr/bin/env ruby

require 'set'

module Dataknife
  module Plugins
    class ColsepPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Print indicated column(s) from input lines w/ separator"
        @syntax = "colsep S C1 [C2] ..."
        @command = "colsep"
      end

      def main(args)
        if args.length < 2 or args[1..-1].any? {|i| i.to_i == 0}
          print "ERROR: provide positive column numbers to print"
        else
          sep = args[0]
          columns = args[1..-1].map {|i| i.to_i - 1}
          STDIN.each_line do |line|
            fields = line.chomp.split(/#{sep}/)
            columns.each do |column|
              print fields[column] + " " if fields.length >= column
            end
            puts
          end
        end
      end
    end

    ColsepPlugin.new
  end
end


