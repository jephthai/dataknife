#!/usr/bin/env ruby

require 'set'

module Dataknife
  module Plugins
    class JSONPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Pretty print the input JSON"
        @syntax = "json"
        @command = "json"
      end

      def main(args)
        require 'json'
        string = STDIN.read()
        json   = JSON.parse(string)
        pretty = JSON.pretty_generate(json)
        puts pretty
      end
    end

    JSONPlugin.new
  end
end


