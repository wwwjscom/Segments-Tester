#!/usr/bin/ruby -w


##############################################
########           Jason Soo          ########
######## Sun Jun  7 00:44:48 CDT 2009 ########
##############################################


require 'mysql'
require 'date'


class DB


  def initialize(user, pass, database)
    @user = user
    @pass = pass
    @database = database
  end


  # meta function for calling all
  # methods needed to add a tweet
  def add(data)
    # get the associated movie id and add
    # it to the data hash
    movie_id = get_movie_id(data[:movie_name])
    movie_id = movie_id[0].fetch_row
    data[:movie_id] = movie_id

    # insert the data hash into our
    # table
    insert(data)
  end


  def get_movie_id(movie_name)
    q = ["SELECT id FROM movies WHERE name = '#{movie_name}'"]
    _query(q)
  end


  # Add the data hash to the tweets table
  def insert(data)
    q = ["
          INSERT INTO tweets 
          (username, text, movie_id) VALUES 
          ('#{data[:username]}', '#{data[:text]}', '#{data[:movie_id]}')
        "]
    _query(q)
  end


  # delete the item with id from items table
  def delete_item(id)
    q = ["DELETE FROM items WHERE id = #{id}"]
    _query(q)
  end



  #------ private methods


  # execute an array of queries q
  def _query(q)
    ret = []
    begin
      db = Mysql.real_connect('localhost', @user, @pass, @database)
      q.each do |query|
        ret.push(db.query(query))
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


#tweet = { :text => 'lawl the hangonver', :username => 'jsoo', :movie_name => 'the hangover' }
#db = DB.new
#db.add(tweet)
