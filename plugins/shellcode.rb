#!/usr/bin/env ruby

require 'base64'

module Shellcode
  module Plugins
    class ShellExecPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Emits a C program that executes the input as shellcode"
        @syntax = "shellexec"
        @command = "shellexec"
      end

      def main(args)
        output = "  unsigned char array[] __attribute__ ((section(\".text\"))) = {\n"
        data = STDIN.read.unpack("C*")
        data.each_slice(16) do |group|
          row = group.map { |i| sprintf("0x%02x", i) }.join(", ")
          output += "    #{row},\n"
        end
        output = output[0..-3] + "};\n"
        output += "\nint main() {\n"
        output += "  ((void(*)())array)();\n"
        output += "}\n"
        puts(output)
      end
    end

    ShellExecPlugin.new
  end
end


