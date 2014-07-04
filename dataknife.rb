#!/usr/bin/env ruby
#
# Inception: I keep running into data, and it frustrates me to deal with it.
# There are lots of things I want to do with data, and there are too many
# separate tools for it.  Ruby can accomplish almost all of my purposes...
# perhaps I can make a data-swiss-army-knife.
#
# Author:  Josh Stone
# Contact: yakovdk@gmail.com
# Date:    2014-07-02
#
#

require 'rubygems'

module Dataknife
  load File.dirname(File.realdirpath(__FILE__))+"/modules.rb"
  Plugins.init

  if ARGV.length == 0
    puts
    puts "------------------------------------------------------------------------"
    puts "    Data Knife - by Josh Stone (yakovdk@gmail.com) - (C) 2014"
    puts "------------------------------------------------------------------------"
    puts
    puts "usage: #{$0} <cmd>"
    puts
    puts "  Most plugins read from standard input and print the result"
    puts "  on the standard output stream."
    puts
    Plugins.plugins.sort {|i,j| i.command <=> j.command}.each do |plugin|
      printf "  %-20s %s\n", plugin.syntax, plugin.help
    end
    puts
    exit 1
  end

  Plugins.plugins.each do |plugin|
    if ARGV[0] == plugin.command
      plugin.main(ARGV[1..-1])
    end
  end
end
