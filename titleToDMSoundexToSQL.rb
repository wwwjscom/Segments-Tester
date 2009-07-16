#! /usr/bin/env ruby -w

#########################################################
#
# Inserts a bunch of titles, breaks them into soundex codes 
# and inserts them into the specified 'type' table name.
#
# This script is only used to setup the table that will be
# queries
#
##########################################################


################ CONFIGS ####################

type = 'query_logs' # h, t, o, m, p, new_queries
skip_queries = ['myjava', 'sea;klefjsdf'] # Skip these queries because they make our program crash

############### /CONFIGS ####################


# Erase any old SQL files laying around
begin
	File.delete('/tmp/dm_soundex_sql.sql')
rescue

end

soundex_hash = Hash.new()

file = File.open("#{type}.txt", "r")
while (query = file.gets)

	query = query.chop.downcase
  begin
  if query[0].chr == 'j' then next end
  if query[1].chr == 'j' then next end
  if query[2].chr == 'j' then next end
  next if skip_queries.include?(query)
  rescue
  end

  print "Query: #{query}"
	# Convery query to dm soundex
  system("perl dm-soundex.pl \"#{query}\" > /tmp/tmp-dm.txt")

  f = File.open('/tmp/tmp-dm.txt')
  dm_soundex_query = f.gets.chop
  #dm_soundex_query = f.gets
  print " - #{dm_soundex_query}\n"
  soundex_hash[query] = dm_soundex_query
  f.close

end
file.close

# Write assembled soundex's to soundex_sql file in sql insert calls
sql_file = File.new('/tmp/dm_soundex_sql.sql', 'a')

soundex_hash.each do |query, soundex|

  sql_file.puts "\n\n--- Query: #{query}"

  sql_file.puts "INSERT INTO dm_soundex.#{type} VALUES ('#{query}', '#{soundex}');"

end
sql_file.close
