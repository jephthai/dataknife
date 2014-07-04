#!/usr/bin/env ruby

module Dataknife
  module Plugins
    class EncryptPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Encrypt input with indicated cipher ('list' to enum) and key"
        @syntax = "encrypt algo key"
        @command = "encrypt"
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
            require 'crypt/stringxor'
            print STDIN.read ^ args[1]
          else
            crypt = getcrypt args[0], args[1]
            print crypt.encrypt_string(STDIN.read)
          end
        end
      end
    end

    EncryptPlugin.new
  end
end


