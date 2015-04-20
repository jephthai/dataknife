#!/usr/bin/env ruby

require 'set'
#
# OK, this one is pretty crazy.  The idea is that you may have some output
# or documentation that contains IP addresses, and you want to share it but
# the IP addresses are sensitive somehow.  This will scan through the input
# and consistently replace every IP address with a randomized alternative.
# 
# By "consistently", I mean that any particular given IP address will 
# always be replaced with the same one for a certain run of the program. 
# Note that subsequent runs on the same input will not be consistent with
# former runs, as the selection of IP -> IP mappings is done with the 
# Ruby PRNG, not with a reversible mechanism.  You wouldn't want it to be
# reversible, right?  That would defeat the purpose.
# 

module Dataknife
  module Plugins

    class IPs
      def initialize
        @octets = {}
      end

      def checkin(ip)
        @octets[ip[0]] = [rand(256),{}] unless @octets[ip[0]]
        @octets[ip[0]][1][ip[1]] = [rand(256),{}] unless @octets[ip[0]][1][ip[1]]
        @octets[ip[0]][1][ip[1]][1][ip[2]] = [rand(256),{}] unless @octets[ip[0]][1][ip[1]][1][ip[2]]
        @octets[ip[0]][1][ip[1]][1][ip[2]][1][ip[3]] = [rand(256),{}] unless @octets[ip[0]][1][ip[1]][1][ip[2]][1][ip[3]]
      end

      def replace(block)
        @octets.each do |k1,o1|
          o1[1].each do |k2,o2|
            o2[1].each do |k3,o3|
              o3[1].each do |k4,o4|
                from = "#{k1}.#{k2}.#{k3}.#{k4}"
                to   = "#{o1[0]}.#{o2[0]}.#{o3[0]}.#{o4[0]}"
                # STDERR.puts "Changing #{from} to #{to}"
                block.gsub!(from, to)
              end
            end
          end
        end
        return block
      end
    end

    class MaskipsPlugin < Dataknife::Plugins::DefaultPlugin
      def initialize
        super
        @help = "Anonymize IP addresses from the input"
        @syntax = "maskips"
        @command = "maskips"
      end

      def main(args)
        ips = IPs.new
        STDIN.each_line do |line|
          line.scan(/\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b/).each do |ip|
            ips.checkin(ip.split(/\./))
          end
          puts ips.replace(line)
        end
      end
    end

    MaskipsPlugin.new
  end
end


