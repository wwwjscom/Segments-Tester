#! /usr/bin/env ruby -w
require 'rubygems'
require 'parseconfig'
# Access config: config.get_value('test') 

class Configure

  def self.get_parser
    ParseConfig.new(File.join(ROOT_DIR, 'CONFIG'))
  end

end
