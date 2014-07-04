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

require 'pp'

module Dataknife
  load File.dirname(__FILE__)+"/modules.rb"
  Plugins.init
  pp Plugins.plugins
end
