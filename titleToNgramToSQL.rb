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


################ CONFIGS ####################

type = 'query_logs_correct' # h, t, o, m, p, new_queries

############### /CONFIGS ####################

# Erase any old SQL files laying around
begin
	File.delete('/tmp/ngram_sql.sql')
rescue

end

file = File.open("#{type}.txt", "r")
while (query = file.gets)

	# Convery query to lowercase
	query = query.chop.downcase

	# Write query to file to be read by count.pl
	in_file = File.new("/tmp/in.txt", 'w')
	in_file.puts query
	in_file.close

	# Invoke ngrams script, output to out.txt

  # Uncomment following line to use trigrams @ word level
	system("/Users/wwwjscom/Downloads/Text-NSP-1.09/bin/count.pl --token /Users/wwwjscom/Downloads/Text-NSP-1.09/bin/REGEX --ngram 3 --window 3 /tmp/out.txt /tmp/in.txt")

  # Uncomment following line to use 4grams @ word level
	#system("/Users/wwwjscom/Downloads/Text-NSP-1.09/bin/count.pl --token /Users/wwwjscom/Downloads/Text-NSP-1.09/bin/REGEX --ngram 4 --window 4 /tmp/out.txt /tmp/in.txt")

	# Iterate over out.txt assembling ngrams
	out_file = File.open("/tmp/out.txt", 'r')
	i = 0
	ngrams = []
	while (line = out_file.gets)
		if i != 0:
			line.chop
      # uncomment if using trigrams
			ngrams.push "#{line[0].to_i.chr}#{line[3].to_i.chr}#{line[6].to_i.chr}"

      # uncomment if using 4grams
			#ngrams.push "#{line[0].to_i.chr}#{line[3].to_i.chr}#{line[6].to_i.chr}#{line[9].to_i.chr}"
		end
		i += 1
	end

	# Write assembled ngrams to ngram_sql file in sql insert calls
	sql_file = File.new('/tmp/ngram_sql.sql', 'a')
	sql_file.puts "\n\n--- Query: #{query}"
	ngrams.each { |ngram|
    # uncomemnt if using trigrams
		sql_file.puts "INSERT INTO ngrams.#{type} VALUES ('#{query}', '#{ngram}');"
    # uncomment if using 4grams
		#sql_file.puts "INSERT INTO ngrams.#{type}_4grams VALUES ('#{query}', '#{ngram}');"
	}
	sql_file.close

	# Delete the query file
	File.delete('/tmp/out.txt')

end
file.close
