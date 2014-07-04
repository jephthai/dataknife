#!/usr/bin/env rub

module Dataknife
  module Plugins
    @@plugins = []

    def Plugins.plugins
      return @@plugins
    end

    def Plugins.init(dir=File.dirname(__FILE__)+"/plugins")
      Dir.glob("#{dir}/*.rb") do |plugin|
        begin
          load plugin
        rescue
          puts "error loading plugin #{plugin}"
        end
      end
    end

    class DefaultPlugin
      attr_accessor :help, :syntax, :command
      def initialize
        @command = "default"
        @syntax = "default"
        @help = "Default plugin does nothing"
        Plugins.plugins << self
      end

      def main(args)
        puts "Plugin::main called with #{args.length} args -- override to actually do stuff"
      end
    end

  end
end
