#! /usr/bin/env ruby -w

############################################################
#
# This file reads in a file called queries.txt             #
# which contains a query to be run.  This query            #
# is turned into ngrams and written to out.txt,            #
# then assembled into ngrams which can be read             #
# by our program.  Therafter, we query the ngrams          #
# engine and write the results to votes/ngram_results.txt  #
#
############################################################

################ CONFIGS ####################

#@@types = Array['h', 't', 'o', 'm', 'p'] # The tables we wish to query
@@types = Array['t', 'o', 'm', 'p'] # The tables we wish to query (no h table)
PATH = Dir.getwd

############### /CONFIGS ####################


class Ngrams

  attr_accessor :type #either 3 or 4 gram

  def initialize (type)
    @type = type
  end


  def query
    file = File.open("#{PATH}/queries.txt", "r")
    while (query = file.gets)

      # Convery query to lowercase
      query = query.chop.downcase

      # Write query to file to be read by count.pl
      in_file = File.new("#{PATH}/in.txt", 'w')
      in_file.puts query
      in_file.close

      # Invoke ngrams script, output to out.txt
      if @type == 3 then
        system("/Users/wwwjscom/Downloads/Text-NSP-1.09/bin/count.pl --token /Users/wwwjscom/Downloads/Text-NSP-1.09/bin/REGEX --ngram 3 --window 3 #{PATH}/out.txt #{PATH}/in.txt")
      elsif @type == 4 then
        system("/Users/wwwjscom/Downloads/Text-NSP-1.09/bin/count.pl --token /Users/wwwjscom/Downloads/Text-NSP-1.09/bin/REGEX --ngram 4 --window 4 #{PATH}/out.txt #{PATH}/in.txt")

      end

      # Iterate over out.txt assembling ngrams
      out_file = File.open("#{PATH}/out.txt", 'r')
      i = 0
      ngrams = []
      while (line = out_file.gets)
        if i != 0:
          line.chop

          if @type == 3 then
            ngrams.push "#{line[0].to_i.chr}#{line[3].to_i.chr}#{line[6].to_i.chr}"
          elsif @type == 4 then
            ngrams.push "#{line[0].to_i.chr}#{line[3].to_i.chr}#{line[6].to_i.chr}#{line[9].to_i.chr}"

          end
        end
        i += 1
      end

      # Query each ngram for its query then vote on queries
      votes = Hash.new
      @@types.each { |table|
        ngrams.each { |ngram|

          if @type == 3 then
            system("mysql -u root --password=root ngrams -e 'SELECT query INTO OUTFILE \"#{PATH}/query_result.txt\" FIELDS TERMINATED BY \",\" LINES TERMINATED BY \"\n\" FROM #{table} WHERE ngram = \"#{ngram}\";'")
          elsif @type == 4 then
            system("mysql -u root --password=root ngrams -e 'SELECT query INTO OUTFILE \"#{PATH}/query_result.txt\" FIELDS TERMINATED BY \",\" LINES TERMINATED BY \"\n\" FROM #{table}_4grams WHERE ngram = \"#{ngram}\";'")
          end

          results = File.open("#{PATH}/query_result.txt", 'r')
          while (vote = results.gets)
            vote = vote.chop

            begin
              i = votes.fetch(vote)
            rescue IndexError=>e
              i = 0
            end

            votes[vote] = i+1
          end

          results.close
          File.delete("#{PATH}/query_result.txt")
        }
      }



      votes_file = File.new("#{PATH}/votes/ngram_results.txt", 'w') # UNCOMMENT TO WRITE TO FILE
      # Write the votes to a results file
      # Sort the hash by value
      votes.sort{|a,b| a[1]<=>b[1]}.reverse.each { |elem|
        votes_file.puts "#{elem[1]}, #{elem[0]}" # UNCOMMENT TO WRITE TO FILE
      }
      votes_file.close # UNCOMMENT TO WRITE TO FILE

      # Delete the query file
      File.delete("#{PATH}/out.txt")

    end
    file.close
  end
end
