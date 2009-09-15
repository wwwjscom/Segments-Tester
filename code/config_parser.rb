#! /usr/bin/env ruby -w
require 'parseconfig'
# Access config: config.get_value('test') 
@config = ParseConfig.new("#{ROOT_DIR}/CONFIG")
@@config = ParseConfig.new("#{ROOT_DIR}/CONFIG")
