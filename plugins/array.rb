#!/usr/bin/env ruby

require 'base64'

module CArray
  module Plugins
    class ArrayPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Encodes the input as a C byte array"
        @syntax = "array [fmt]"
        @command = "array"
        @langs = ["c", "cs"]

        @primes = [ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41,
          43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103,
          107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167,
          173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233,
          239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307,
          311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379,
          383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449,
          457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523,
          541]
      end

      def emit_c(data)
        output = "  unsigned char[] array = {\n"
        data.each_slice(16) do |group|
          row = group.map { |i| sprintf("0x%02x", i) }.join(", ")
          output += "    #{row},\n"
        end
        puts(output[0..-3] + "};\n")
      end

      def shift_or(number)
        return "0" if number == 0

        bin = number.to_s(2)
        max = bin.scan(/(0+)/).flatten.max { |i,j| i.length <=> j.length }
        return number.to_s if not max

        offset = bin.index(max)
        base = bin[0...offset].to_i(2)
        digits = max.length
        residual = bin[offset + digits..-1].to_i(2)
        shift = bin.length - offset

        suffix = number > 1<<31-1 ? "ul" : ""

        return residual == 0 ? "#{base}#{suffix}<<#{shift}" : "#{base}#{suffix}<<#{shift}|#{residual}"
      end

      def dec_string(number)
        if number > 1<<30
          return "0x" + number.to_s(16)
        else
          return number.to_s
        end
      end

      def hex_string(number)
        if number > 1<<30
          return "0x" + number.to_s(16)
        else
          return "0x" + number.to_s(16)
        end
      end

      def number_options(number)
        return [
          hex_string(number),       # hexadecimal encoding
          dec_string(number),       # standard decimal
          shift_or(number),         # shifted base + residual
        ]
      end        

      def pad(nums, length)
        return nums + ([0] * (length - nums.length))
      end

      def emit_cs(data)
        output = "  byte[] array = new byte[#{data.length}];\n" +
                 "  Buffer.BlockCopy(new ulong[] {"

        count = 0
        data.each_slice(8) do |group|
          count += 1
          # output += "\n" if count % 8 == 0
          ulong = pad(group, 8).pack("C*").unpack("Q")[0]

          candidates = number_options(ulong)

          string = candidates.min { |i,j| i.length <=> j.length }
          output += string + ","
        end

        puts(output[0..-2] + "}, 0, array, 0, #{data.length});")

      end
      
      def header(lang, length)
        case lang
        when "c"
        when "cs"
        end
      end

      def footer(lang, length)
        case lang
        when "c"
          return "}\n"
        when "cs"
          return "}, 0, array, 0, #{length});\n"
        end
      end

      def main(args)
        lang = args.length > 0 ? args[0] : "c"

        data = STDIN.read.unpack("C*")
        case lang
        when "c"
          emit_c(data)
        when "cs"
          emit_cs(data)
        else
          puts("Unknown lang:")
        end
      end

    end
    
    ArrayPlugin.new
  end
end
