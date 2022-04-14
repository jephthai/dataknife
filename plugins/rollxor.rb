#!/usr/bin/env ruby

module RollXor
  module Plugins
    class RollXorPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Encodes / decodes the input with a rolling XOR 'cipher'"
        @syntax = "rollxor [key]"
        @command = "rollxor"
      end

      def main(args)
        if args.length == 0
          puts("Error: must specify key")
        else
          key = args[0].to_i
          output = []

          begin
            while block = STDIN.sysread(1024)
              STDOUT.syswrite(output.pack("C*"))
              output = []
              block.each_byte do |byte|
                output << (byte ^ key)
                key = (key + 1) & 0xff
              end
            end
          rescue
          end

          STDOUT.syswrite(output.pack("C*"))
        end
      end
    end
    
    RollXorPlugin.new
  end
end
