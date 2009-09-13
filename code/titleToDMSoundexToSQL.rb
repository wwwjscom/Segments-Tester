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

require 'directories_setup'

################ CONFIGS ####################

type = 'query_logs_correct' # h, t, o, m, p, new_queries
skip_queries = ['myjava', 'sea;klefjsdf'] # Skip these queries because they make our program crash

############### /CONFIGS ####################


# Erase any old SQL files laying around
begin
	File.delete("#{TMP_DIR}/dm_soundex_sql.sql")
rescue

end

soundex_hash = Hash.new()
i = 0

file = File.open("#{type}.txt", "r")
while (query = file.gets)
  i += 1

	query = query.chop.downcase
  begin
    if skip_queries.include?(query) || query[0].chr == 'j' || query[1].chr == 'j' || query[2].chr == 'j'
      puts "--- Skipping #{i}: #{query}"
      next
    end
  rescue
      puts "--- Skipping #{i}: #{query}"
  end

  print "Query: #{i} #{query}"
	# Convery query to dm soundex
  system("perl dm-soundex.pl \"#{query}\" > #{TMP_DIR}/tmp-dm.txt")

  f = File.open("#{TMP_DIR}/tmp-dm.txt")
  dm_soundex_query = f.gets.chop
  #dm_soundex_query = f.gets
  print " - #{dm_soundex_query}\n"
  soundex_hash[query] = dm_soundex_query
  f.close

end
file.close

# Write assembled soundex's to soundex_sql file in sql insert calls
sql_file = File.new("#{TMP_DIR}/dm_soundex_sql.sql", 'a')

soundex_hash.each do |query, soundex|

  sql_file.puts "\n\n--- Query: #{query}"

  sql_file.puts "INSERT INTO dm_soundex.#{type} VALUES ('#{query}', '#{soundex}');"

end
sql_file.close
