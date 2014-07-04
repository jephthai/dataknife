#!/usr/bin/env ruby

require 'set'

module Dataknife
  module Plugins
    class IntersectPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Print intersection of provided files / input"
        @syntax = "intersect f1 [f2]..."
        @command = "intersect"
      end

      def snorf(stream)
        set = Set.new
        stream.each_line do |line|
          set.add line.strip
        end
        return set
      end

      def main(args)
        if args.length < 1
          puts "ERROR: provide at least one file to intersect"
        elsif not args.map {|i| File.exists? i}.all?
          puts "ERROR: all provided files must exist"
        else
          sets = []
          sets << snorf(STDIN) if args.length == 1
          args.each {|file| sets << snorf(open(file))}
          i = sets.inject {|intersection, nextset| intersection.intersection nextset}
          i.each {|i| puts i}
        end
      end
    end

    IntersectPlugin.new
  end
end


