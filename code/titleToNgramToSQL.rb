#! /usr/bin/env ruby -w
#########################################################
#
# Inserts a bunch of titles, breaks them into ngrams
# and inserts them into the specified 'type' table name.
#
# This script is only used to setup the table that will be
# queries
#
##########################################################

require 'directories_setup'
require 'config_parser'

################ CONFIGS ####################

def options(param)

  i = 0
  match = nil
  ARGV.each do |valeur|

    if (valeur == '-' + param.to_s)
      match = ARGV[i+1]
    end
    i += 1
  end
  return match
end


type = nil
@n = options('n').to_i
if @n == 3
  type = "#{@config.get_value('correct_tables')}_3grams" # h, t, o, m, p, new_queries
elsif @n == 4
  type = "#{@config.get_value('correct_tables')}_4grams" # h, t, o, m, p, new_queries
end

puts @n
puts type

############### /CONFIGS ####################

# Erase any old SQL files laying around
begin
	File.delete("#{TMP_DIR}/ngram_sql.sql")
rescue

end

count = 0 # DEBUG

file = File.open("#{type}.txt", "r")
while (query = file.gets)

	# Convery query to lowercase
	query = query.chop.downcase

	# Write query to file to be read by count.pl
	in_file = File.new("#{TMP_DIR}/in.txt", 'w')
	in_file.puts query
	in_file.close

	# Invoke ngrams script, output to out.txt

  if @n == 3
    system("#{CODE_DIR}/Text-NSP-1.09/bin/count.pl --token #{CODE_DIR}/Text-NSP-1.09/bin/REGEX --ngram 3 --window 3 #{TMP_DIR}/out.txt #{TMP_DIR}/in.txt")
  elsif @n == 4
    system("#{CODE_DIR}/Text-NSP-1.09/bin/count.pl --token #{CODE_DIR}/Text-NSP-1.09/bin/REGEX --ngram 4 --window 4 #{TMP_DIR}/out.txt #{TMP_DIR}/in.txt")
  end

	# Iterate over out.txt assembling ngrams
  begin
    out_file = File.open("#{TMP_DIR}/out.txt", 'r')
  rescue
    next
  end
	i = 0
	ngrams = []
	while (line = out_file.gets)
		if i != 0:
			line.chop
      if @n == 3
        ngrams.push "#{line[0].to_i.chr}#{line[3].to_i.chr}#{line[6].to_i.chr}"
      elsif @n == 4
        ngrams.push "#{line[0].to_i.chr}#{line[3].to_i.chr}#{line[6].to_i.chr}#{line[9].to_i.chr}"
      end
		end
		i += 1
	end

	# Write assembled ngrams to ngram_sql file in sql insert calls
	sql_file = File.new("#{TMP_DIR}/ngram_sql.sql", 'a')
	sql_file.puts "\n\n--- Query: #{query}"
	ngrams.each { |ngram|
    if @n == 3
      sql_file.puts "INSERT INTO #{@config.get_value('mysql_database')}.#{type}_3grams VALUES ('#{query}', '#{ngram}');"
    elsif @n == 4
      sql_file.puts "INSERT INTO #{@config.get_value('mysql_database')}.#{type}_4grams VALUES ('#{query}', '#{ngram}');"
    end
	}
	sql_file.close

	# Delete the query file
	File.delete("#{TMP_DIR}/out.txt")

  count += 1
end
file.close
