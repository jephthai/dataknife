#!/usr/bin/env ruby

module Dataknife
  module Plugins
    class ShannonPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Calculates the Shannon entropy of the input"
        @syntax = "shannon"
        @command = "shannon"
      end

      def main(args)
        bytes = [0] * 256
        length = 0
        begin
          while(block = STDIN.sysread(1024))
            length += block.length
            block.each_byte do |byte|
              bytes[byte] += 1
            end
          end
        rescue EOFError
        end
        bytes -= [0]
        entropy = bytes.inject(0) do |result, count|
          frequency = count / 1.0 / length
          result - Math.log2(frequency) * frequency
        end
        puts entropy
      end
    end

    ShannonPlugin.new
  end
end


