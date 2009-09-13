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

type = 'census_surnames_soundex' # h, t, o, m, p

############### /CONFIGS ####################



class String

    SoundexChars = 'BPFVCSKGJQXZDTLMNR'
    SoundexNums  = '111122222222334556'
    SoundexCharsEx = '^' + SoundexChars
    SoundexCharsDel = '^A-Z'

    # desc: http://en.wikipedia.org/wiki/Soundex
    def soundex(census = true)
        str = upcase.delete(SoundexCharsDel).squeeze

        str[0 .. 0] + str[1 .. -1].
            delete(SoundexCharsEx).
            tr(SoundexChars, SoundexNums)[0 .. (census ? 2 : -1)].
            ljust(3, '0') rescue ''
    end

    def sounds_like(other)
        soundex == other.soundex
    end
end

# puts "Quadratically".soundex
# 'Q363'

# puts "Quadratically".soundex(false)
# 'Q36324'


# Erase any old SQL files laying around
begin
	File.delete("#{TMP_DIR}/soundex_sql.sql")
rescue

end

soundex_hash = Hash.new()

file = File.open("#{type}.txt", "r")
while (query = file.gets)

	# Convery query to lowercase
	query = query.chop.downcase

  puts "Query: #{query} - #{query.soundex(false)}"
  soundex_hash[query] = query.soundex(false)

end
file.close

# Write assembled soundex's to soundex_sql file in sql insert calls
sql_file = File.new("#{TMP_DIR}/soundex_sql.sql", 'a')

soundex_hash.each do |query, soundex|

  sql_file.puts "\n\n--- Query: #{query}"

  sql_file.puts "INSERT INTO soundex.#{type} VALUES ('#{query}', '#{soundex}');"

end
sql_file.close
