#!/usr/bin/ruby -w
##############################################
########           Jason Soo          ########
######## Sun Jun  7 00:44:48 CDT 2009 ########
##############################################


require 'mysql'


class DB


  def initialize(user, pass, database)
    @user = user
    @pass = pass
    @database = database
  end


  # Abstract query function
  def query(q)
    _query([q])
  end


  #------ private methods


  # execute an array of queries q
  def _query(q)
    ret = []
    begin
      db = Mysql.real_connect('localhost', @user, @pass, @database)
      if q.size == 1
        ret = db.query(q[0])
      else
        q.each do |query|
          ret.push(db.query(query))
        end
      end
    rescue Mysql::Error => e
      puts "Error code: #{e.errno}"
      puts "Error message: #{e.error}"
      puts "Error SQLSTATE: #{e.sqlstate}" if e.respond_to?("sqlstate")
    ensure
      # disconnect from server
      db.close if db
    end
    ret
  end


end
