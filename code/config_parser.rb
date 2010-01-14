#! /usr/bin/env ruby -w
require 'rubygems'
require 'parseconfig'
# Access config: config.get_value('test') 

class Configure

  def get_parser
    return ParseConfig.new(File.join(ROOT_DIR, 'CONFIG'))
  end

end
