#!/usr/bin/env ruby

module Dataknife
  module Plugins
    class DecryptPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Decrypt input with indicated cipher ('list' to enum) and key"
        @syntax = "decrypt algo key"
        @command = "decrypt"
      end

      def printsupported
        puts "Supported ciphers:"
        puts
        puts "  blowfish "
        puts "  rijndael "
        puts "  idea     "
        puts "  xor      "
        puts
      end

      def getcrypt(algo, key)
        case algo
        when "blowfish"
          require 'crypt/blowfish'
          return Crypt::Blowfish.new(key)
        when "aes"
          require 'crypt/rijndael'
          return Crypt::Rijndael.new(key)
        when "idea"
          require 'crypt/idea'
          return Crypt::Idea.new(key)
        else
          printsupported
          exit 1
        end
      end

      def main(args)
        if args.length != 2
          puts "ERROR: provide algorithm and key"
          puts
          printsupported
        elsif args[0] == "list"
          printsupported
        else
          if args[0] == "xor"
            require 'xorcist'
	    puts("XORCIST in use")
            input = STDIN.read
	    cipher = Xorcist.xor(input, args[1] * (input.length / args[1].length))
	    print cipher
            # dups  = (input.length / args[1].length) + 1
            # print input ^ (args[1] * dups)
          else
            crypt = getcrypt args[0], args[1]
            print crypt.decrypt_string(STDIN.read)
          end
        end
      end
    end

    DecryptPlugin.new
  end
end


