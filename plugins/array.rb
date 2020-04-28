#!/usr/bin/env ruby

require 'base64'

module CArray
  module Plugins
    class ArrayPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Encodes the input as a C byte array"
        @syntax = "array"
        @command = "array"
      end

      def main(args)
        output = "  unsigned char[] array = {\n"
        data = STDIN.read.unpack("C*")
        data.each_slice(16) do |group|
          row = group.map { |i| sprintf("0x%02x", i) }.join(", ")
          output += "    #{row},\n"
        end
        puts(output[0..-3] + "};\n")
      end
    end

    ArrayPlugin.new
  end
end


