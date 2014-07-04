#!/usr/bin/env ruby

module Dataknife
  module Plugins
    class ChexPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Colorized hex-dump of input"
        @syntax = "chex"
        @command = "chex"
        @esc = "\x1b"
        @reset = "[0m"
        @colormap = {
          ("\x00".."\x00") => 244,
          ("\x01".."\x1f") => 216,
          ("\x21".."\x2f") => 39,
          ("\x41".."\x7e") => 39,
          ("\x30".."\x3f") => 36,
          ("\x7f".."\x7f") => 83
        }
      end

      def colorize(i, string)
        color = 228
        @colormap.each do |k,v|
          color = v if k.cover? i
        end
        return "#{@esc}[0;38;5;#{color}m#{string}#{@esc}#{@reset}"
      end

      def main(args)
        offset = 0
        begin
          while(block = STDIN.sysread(16))
            hexes = block.unpack("H*")[0].scan(/../)
            printf("%010x ", offset)
            hexes.each do |i| 
              print colorize(i.hex.chr, i) + " "
            end
            print ("   " * (16 - block.length)) + " ["
            block.each_byte do |i| 
              if (' '..'~').cover? i.chr
                print colorize(i.chr, i.chr)
              else
                print "."
              end
            end
            puts "]"
            offset += block.length
          end
        rescue EOFError
        end
      end
    end

    ChexPlugin.new
  end
end

