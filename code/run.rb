#! /usr/bin/env ruby -w

require 'rubygems'
require 'parseconfig'
# Queries both engines using a specified test

require 'db'
load "queryToNgramToVote.rb"
load "soundex.rb"

# Access config: config.get_value('test') 
@config = ParseConfig.new("#{Dir.getwd}/CONFIG")

########### CONFIG ################
@mysql_username = @config.get_value('mysql_username')
@mysql_password = @config.get_value('mysql_password')
@mysql_database = @config.get_value('mysql_database')
@test_type      = @config.get_value('tests')

@correct_tables = []
@config.get_value('correct_tables').split(', ').each do |t|
  @correct_tables << t
end

@dm_soundex_sql = DB.new(@mysql_username, @mysql_password, @mysql_database)
@ngrams_sql     = DB.new(@mysql_username, @mysql_password, @mysql_database)

@@path = Dir.getwd

########## HELPERS ################
class Array
  def shuffle
    sort_by { rand }
  end

  def shuffle!
    self.replace shuffle
  end
end

class String
	def dropChar
		begin
			len = self.length
			self[rand(len)] = ""
		rescue
		end
		return self
	end

	def dropChars times
		for i in (1..times)
			self.dropChar
		end
		return self
	end

	def addChar
		len = self.length
    letter = 'j'
    while letter == 'j' do
      letter = (rand(26) + 97).chr
    end
		self.insert(rand(len), letter)
		return self
	end

	def addChars times
		for i in (1..times)
			self.addChar
		end
		return self
	end

	def replaceChar
		len = self.length

    letter = 'j'
    while letter == 'j' do
      letter = (rand(26) + 97).chr
    end

		self[rand(len)] = letter
		return self
	end

	def replaceChars times
		for i in (1..times)
			self.replaceChar
		end
		return self
	end

	def swapChar
		len = self.length
		
		i_a = rand(len)
		i_b = i_a

		while i_a == i_b do i_b = rand(len) end

		swap_a = self[i_a].chr
		swap_b = self[i_b].chr

		while swap_a == swap_b do
			i_b = rand(len)
			swap_b = self[i_b].chr
		end

		self[i_a] = swap_b
		self[i_b] = swap_a
		return self
	end

	def swapChars times
		for i in (1..times)
			self.swapChar
		end
		return self
	end

	def swapAdjChar
		len = self.length
		
		i_a = rand(len - 1)
		while i_a >= len or i_a < 0 do i_a = rand(len - 1) end

		i_b = i_a + 1

		swap_a = self[i_a].chr
		swap_b = self[i_b].chr

		self[i_a] = swap_b
		self[i_b] = swap_a
		return self
	end
end



def main test

	######## MAIN ###########

	j = 1

	@ngram_results = Array.new
	@our_results = Array.new
	@four_grams_results = Array.new
	@dm_soundex_results = Array.new

	for i in (0..(TEN_PERCENT*MULTIPLIER).to_i)

		orig_query = @correct_queries[i].to_s
		mispelled_query = String.new(orig_query)

		if orig_query.length > 25 then
			puts "skipping, query is too long: #{orig_query}"
			next
		end

		# Fuck up query if we are using the RAND algorithms.
    # Otherwise leave the query as is.
    if @test_type == "RAND"
      mispelled_query = case test
              when "d1": mispelled_query.dropChar
              when "d2": mispelled_query.dropChars(2)
              when "d3": mispelled_query.dropChars(3)
              when "d4": mispelled_query.dropChars(4)
              when "a1": mispelled_query.addChar
              when "a2": mispelled_query.addChars(2)
              when "a3": mispelled_query.addChars(3)
              when "a4": mispelled_query.addChars(4)
              when "r1": mispelled_query.replaceChar
              when "r2": mispelled_query.replaceChars(2)
              when "r3": mispelled_query.replaceChars(3)
              when "r4": mispelled_query.replaceChars(4)
              when "s1": mispelled_query.swapAdjChar
              when "s2": mispelled_query.swapChars(2)
              when "s3": mispelled_query.swapChars(3)
              when "s4": mispelled_query.swapChars(4)
      end
    else
      #mispelled_query = orig_query
      #mispelled_query = @mispelled_queries[i].to_s
      mispelled_query = @mispelled_queries.shift.to_s
    end

		#puts "Orig: #{orig_query}, new: #{mispelled_query}"

		if mispelled_query.length <= 3
			puts "Skipping...Query too short: #{mispelled_query}"
			next
		end

		# Setup query
		queries_file = File.open("#{@@path}/queries.txt", "w")
		queries_file.puts mispelled_query	
		queries_file.close

		# Query our engine
		system("php #{@@path}/searchResults.php '#{mispelled_query}'")	















		#######################################
		#######################################
		##### DM SOUNDEX ENGINE....GO #########
		#######################################
		#######################################

		# reset vars
		dm_soundex_result_hash = Hash.new
		result_hash = Hash.new
		dm_soundex_probability = 0
		total_votes = 0
		rank = 1
		found = 0
		match_rank = 0
		probability = 0
		match_votes = 0


		#puts mispelled_query

		begin
			if mispelled_query.include? 'j' then
				puts "Skipping....j...."
				next
			end
		rescue
		end 

		#print "Query: #{mispelled_query}"
		# Convery mispelled_query to dm soundex
		system("perl dm-soundex.pl \"#{mispelled_query}\" > /tmp/tmp-dm.txt")

		f = File.open('/tmp/tmp-dm.txt')
		dm_soundex_mispelled_query = f.gets.chop
		#print " - #{dm_soundex_mispelled_query}\n"
		f.close

		#tables = Array['t', 'p', 'm', 'o', 'h']


		#puts "Orig Query: #{orig_query}, Query: #{mispelled_query}, soundex_mispelled_query: #{soundex_mispelled_query}"

		@correct_tables.each do |table|

      dm_soundex_results = Array.new

      results = @dm_soundex_sql.query("SELECT query FROM #{table}_dm_soundex WHERE dm_soundex = \"#{dm_soundex_mispelled_query}\";")
      results.each do |result|
        dm_soundex_results.push(result.to_s)
      end

      dm_soundex_results.each do |vote|
        begin
          dm_soundex_result_hash[vote] += 1
        rescue
          dm_soundex_result_hash[vote] = 1
        end
      end

    end

		##
		##
		##
		##
		## MUST FIND A WAY TO SORT A HASH BASED ON ITS VOTES
		#@
		#@
		#@
		#@
		#@


		# loop through each line to see if it matches our original query
		rank = 1
		dm_soundex_found = 0
		dm_soundex_match_rank = 0
		dm_soundex_result_hash.each do |suggestion, votes|

			#puts ".#{suggestion}. *#{orig_query}* with #{votes} votes out of #{soundex_result_hash.size}"
			if suggestion.downcase == orig_query.downcase then
				#puts "DM---SOUNDEX4TW"
				dm_soundex_match_rank = rank
				dm_soundex_found = 1
			end

			rank += 1
		end

		#puts "Match Rank: #{soundex_match_rank} out of #{soundex_result_hash.size}"

		probability = nil

		# Disreguard any finds whos rank is > CUTOFF
		if dm_soundex_match_rank > CUTOFF then dm_soundex_found = 0 end

		# Make the match_rank - if it wasnt found or was too high
		if dm_soundex_match_rank > CUTOFF or dm_soundex_found == 0 then dm_soundex_match_rank = '-' end

		dm_soundex_result_hash = Hash["Orig Query", orig_query, "New Query", mispelled_query, "Found", dm_soundex_found, "Match Rank", dm_soundex_match_rank, "Rank", rank-1, "Probability", probability]
		@dm_soundex_results.push(dm_soundex_result_hash)




























#		#######################################
#		#######################################
#		####### SOUNDEX ENGINE....GO ##########
#		#######################################
#		#######################################
#
#		# reset vars
#		soundex_result_hash = Hash.new
#		result_hash = Hash.new
#		soundex_probability = 0
#		total_votes = 0
#		rank = 1
#		found = 0
#		match_rank = 0
#		probability = 0
#		match_votes = 0
#
#
#		soundex_mispelled_query = mispelled_query.soundex(false)
#
#		@tables = Array['t', 'p', 'm', 'o', 'h']
#
#
#		#puts "Orig Query: #{orig_query}, Query: #{mispelled_query}, soundex_mispelled_query: #{soundex_mispelled_query}"
#
#		@tables.each do |table|
#
#			system("mysql -u root --password=root soundex -e 'SELECT query INTO OUTFILE \"#{@@path}/query_result.txt\" FIELDS TERMINATED BY \",\" LINES TERMINATED BY \"\n\" FROM #{table} WHERE soudex = \"#{soundex_mispelled_query}\";'")
#			soundex_results = File.open("#{@@path}/query_result.txt", 'r')
#
#			while vote = soundex_results.gets do
#
#				vote = vote.chomp!
#				begin
#					soundex_result_hash[vote] += 1
#				rescue
#					soundex_result_hash[vote] = 1
#				end
#			end
#
#			File.delete("#{@@path}/query_result.txt")
#		end
#
#		##
#		##
#		##
#		##
#		## MUST FIND A WAY TO SORT A HASH BASED ON ITS VOTES
#		#@
#		#@
#		#@
#		#@
#		#@
#
#
#		# loop through each line to see if it matches our original query
#		rank = 1
#		soundex_found = 0
#		soundex_match_rank = 0
#		soundex_result_hash.each do |suggestion, votes|
#
#			#puts ".#{suggestion}. *#{orig_query}* with #{votes} votes out of #{soundex_result_hash.size}"
#			if suggestion.downcase == orig_query.downcase then
#				#puts "SOUNDEX4TW"
#				soundex_match_rank = rank
#				soundex_found = 1
#			end
#
#			rank += 1
#		end
#
#		#puts "Match Rank: #{soundex_match_rank} out of #{soundex_result_hash.size}"
#
#		probability = nil
#
#		# Disreguard any finds whos rank is > CUTOFF
#		if match_rank > CUTOFF then soundex_found = 0 end
#
#		# Make the match_rank - if it wasnt found or was too high
#		if match_rank > CUTOFF or soundex_found == 0 then match_rank = '-' end
#
#		soundex_result_hash = Hash["Orig Query", orig_query, "New Query", mispelled_query, "Found", soundex_found, "Match Rank", soundex_match_rank, "Rank", rank-1, "Probability", probability]
#		@soundex_results.push(soundex_result_hash)























		#######################################
		########4444444444444444444444#########
		######## 4GRAMS ENGINE....GO ##########
		########4444444444444444444444#########
		#######################################

		# Query ngrams engine
		four_grams = Ngrams.new(4)
		four_grams.query





		# reset vars
		total_votes = 0
		rank = 1
		four_grams_found = 0
		match_rank = 0
		probability = 0
		match_votes = 0

		# Read in results of ngrams
		four_gram_results_file = File.open("#{@@path}/votes/ngram_results.txt", 'r')

		# loop through each line to see if it matches our original query
		while line = four_gram_results_file.gets
			votes = line.split(', ', 2)[0].to_i
			total_votes += votes

			vote = line.split(', ', 2)[1]
			vote.chomp!

			if vote == orig_query
				match_rank = rank
				match_votes = votes
				four_grams_found = 1
			end

			rank += 1

		end

		probability = (match_votes.to_f/total_votes.to_f)*100


		# Disreguard any finds whos rank is > CUTOFF
		if match_rank > CUTOFF then four_grams_found = 0 end

		# Make the match_rank - if it wasnt found or was too high
		if match_rank > CUTOFF or four_grams_found == 0 then match_rank = '-' end

		result_hash = Hash["Orig Query", orig_query, "New Query", mispelled_query, "Found", four_grams_found, "Match Rank", match_rank, "Rank", rank, "Probability", probability]
		@four_grams_results.push(result_hash)

















		#######################################
		#######################################
		######### OUR ENGINE....GO ############
		#######################################
		#######################################

		# reset vars
		our_result_hash = Hash.new
		result_hash = Hash.new
		use_ngrams = false
		our_probability = 0
		total_votes = 0
		rank = 1
		found = 0
		match_rank = 0
		probability = 0
		match_votes = 0

		# Read in results of our engine
		our_results_file = File.open("#{@@path}/votes/our_results.txt", 'r')

		# loop through each line to see if it matches our original query
		while line = our_results_file.gets
			votes = line.split(', ', 2)[0].to_i
			total_votes += votes

			vote = line.split(', ', 2)[1].downcase
			vote.chomp!

			if vote == orig_query
				match_rank = rank
				match_votes = votes
				found = 1
			end

			rank += 1

		end

		probability = (match_votes.to_f/total_votes.to_f)*100

		#puts "Probability: #{probability} Query: #{mispelled_query}" # DEBUG

		#if probability.to_s == "NaN" then puts "-"*200 end # DEBUG

		# Disreguard any finds whos rank is > CUTOFF
		if match_rank > CUTOFF then found = 0 end

		# Make the match_rank - if it wasnt found or was too high
		if match_rank > CUTOFF or found == 0 then match_rank = '-' end

		if probability.to_f <= 20 or probability.to_s == "NaN" then
			#puts "Very low probability: #{probability}" # DEBUG
			use_ngrams = true
			our_probability = probability.to_f
			our_result_hash = Hash["Orig Query", orig_query, "New Query", mispelled_query, "Found", found, "Match Rank", match_rank, "Rank", rank, "Probability", probability]
		else
			result_hash = Hash["Orig Query", orig_query, "New Query", mispelled_query, "Found", found, "Match Rank", match_rank, "Rank", rank, "Probability", probability]
			@our_results.push(result_hash)
		end





		#######################################
		#######################################
		######## NGRAMS ENGINE....GO ##########
		#######################################
		#######################################

		# Query ngrams engine
		trigrams = Ngrams.new(3)
		trigrams.query

		# reset vars
		total_votes = 0
		rank = 1
		found = 0
		match_rank = 0
		probability = 0
		match_votes = 0

		# Read in results of ngrams
		ngram_results_file = File.open("#{@@path}/votes/ngram_results.txt", 'r')

		# loop through each line to see if it matches our original query
		while line = ngram_results_file.gets
			votes = line.split(', ', 2)[0].to_i
			total_votes += votes

			vote = line.split(', ', 2)[1]
			vote.chomp!

			if vote == orig_query
				match_rank = rank
				match_votes = votes
				found = 1
			end

			rank += 1

		end

		probability = (match_votes.to_f/total_votes.to_f)*100

		# Disreguard any finds whos rank is > CUTOFF
		if match_rank > CUTOFF then found = 0 end

		# Make the match_rank - if it wasnt found or was too high
		if match_rank > CUTOFF or found == 0 then match_rank = '-' end

		result_hash = Hash["Orig Query", orig_query, "New Query", mispelled_query, "Found", found, "Match Rank", match_rank, "Rank", rank, "Probability", probability]
		@ngram_results.push(result_hash)


		if (use_ngrams == true and probability.to_f > our_probability.to_f) or our_probability.to_s == "NaN" then
			#puts "Our new probability is #{probability}" # DEBUG
			result_hash = Hash["Orig Query", orig_query, "New Query", mispelled_query, "Found", found, "Match Rank", match_rank, "Rank", rank, "Probability", probability]
			@our_results.push(result_hash)
			#elsif use_ngrams == true and probability.to_f <= our_probability.to_f then
		elsif use_ngrams == true then
			#puts "ngram probability is #{probability}, sticking with ours of #{our_probability}" # DEBUG
			@our_results.push(our_result_hash)
		end

		puts "#{(TEN_PERCENT*MULTIPLIER).to_i - i} runs left, #{@remaining_tests} tests left"

		#if i >= 2
		#	break
		#end
		j += 1

	end

	puts "Ran #{j} times.\n\n"

end

def writeResults suffix

	combined = Array.new


	our_csv = File.open("#{@@path}/our_results_#{suffix}.csv", "w")

	our_csv.puts "Orig Query,New Query,Found,Match Rank,Rank,Probability"


	#puts "-"*50
	@our_results.each do |run|
		#puts "Orig Query: #{run.fetch('Orig Query')}"
		#puts "New Query: #{run.fetch('New Query')}"
		#puts "Found: #{run.fetch('Found')}"
		#puts "Match Rank: #{run.fetch('Match Rank')}"
		#puts "Rank: #{run.fetch('Rank')}"
		#puts "Probability: #{run.fetch('Probability')}"
		#puts "-"*50

		our_csv.puts "#{run.fetch('Orig Query')},#{run.fetch('New Query')},#{run.fetch('Found')},#{run.fetch('Match Rank')},#{run.fetch('Rank')},#{run.fetch('Probability')}"

		combined.push(run)
	end

	our_csv.close


	ngrams_csv = File.open("#{@@path}/ngram_results_#{suffix}.csv", "w")

	ngrams_csv.puts "Orig Query,New Query,Found,Match Rank,Rank,Probability"


	#puts "-"*50
	@ngram_results.each do |run|
		#puts "Orig Query: #{run.fetch('Orig Query')}"
		#puts "New Query: #{run.fetch('New Query')}"
		#puts "Found: #{run.fetch('Found')}"
		#puts "Match Rank: #{run.fetch('Match Rank')}"
		#puts "Rank: #{run.fetch('Rank')}"
		#puts "Probability: #{run.fetch('Probability')}"
		#puts "-"*50

		ngrams_csv.puts	"#{run.fetch('Orig Query')},#{run.fetch('New Query')},#{run.fetch('Found')},#{run.fetch('Match Rank')},#{run.fetch('Rank')},#{run.fetch('Probability')}"

		combined.push(run)

	end

	ngrams_csv.close



four_grams_csv = File.open("#{@@path}/four_grams_results_#{suffix}.csv", "w")

four_grams_csv.puts "Orig Query,New Query,Found,Match Rank,Rank,Probability"

@four_grams_results.each do |run|

	four_grams_csv.puts "#{run.fetch('Orig Query')},#{run.fetch('New Query')},#{run.fetch('Found')},#{run.fetch('Match Rank')},#{run.fetch('Rank')},#{run.fetch('Probability')}"
	combined.push(run)

end

four_grams_csv.close





#	soundex_csv = File.open("#{@@path}/soundex_results_#{suffix}.csv", "w")
#
#	soundex_csv.puts "Orig Query,New Query,Found,Match Rank,Rank,Probability"
#
#
#	@soundex_results.each do |run|
#
#		soundex_csv.puts "#{run.fetch('Orig Query')},#{run.fetch('New Query')},#{run.fetch('Found')},#{run.fetch('Match Rank')},#{run.fetch('Rank')},#{run.fetch('Probability')}"
#		combined.push(run)
#
#	end
#
#	soundex_csv.close


	dm_soundex_csv = File.open("#{@@path}/dm_soundex_results_#{suffix}.csv", "w")

	dm_soundex_csv.puts "Orig Query,New Query,Found,Match Rank,Rank,Probability"


	@dm_soundex_results.each do |run|

		dm_soundex_csv.puts "#{run.fetch('Orig Query')},#{run.fetch('New Query')},#{run.fetch('Found')},#{run.fetch('Match Rank')},#{run.fetch('Rank')},#{run.fetch('Probability')}"
		combined.push(run)

	end

	dm_soundex_csv.close












	combined_csv = File.open("#{@@path}/combined_results_#{suffix}.csv", "w")

	combined_csv.puts "Orig Query,New Query,Three-grams Found,Ours Found,Four-grams Found,DM Soundex Found,NGrams Match Rank,Ours Match Rank,Four-grams Match Rank,DM Soundex Match Rank,Ngrams Rank,Ours Rank,Ngrams Probability,Ours Probability"


	#puts "-"*50
	i=0
	@ngram_results.each do |run|
		#puts "Orig Query: #{run.fetch('Orig Query')}"
		#puts "New Query: #{run.fetch('New Query')}"
		#puts "Found: #{run.fetch('Found')}"
		#puts "Match Rank: #{run.fetch('Match Rank')}"
		#puts "Rank: #{run.fetch('Rank')}"
		#puts "Probability: #{run.fetch('Probability')}"
		#puts "-"*50

		combined_csv.puts "#{run.fetch('Orig Query')},#{run.fetch('New Query')},#{run.fetch('Found')},#{@our_results[i].fetch('Found')},#{@four_grams_results[i].fetch('Found')},#{@dm_soundex_results[i].fetch('Found')},#{run.fetch('Match Rank')},#{@our_results[i].fetch('Match Rank')},#{@four_grams_results[i].fetch('Match Rank')},#{@dm_soundex_results[i].fetch('Match Rank')},#{run.fetch('Rank')},#{@our_results[i].fetch('Rank')},#{@four_grams_results[i].fetch('Rank')},#{@dm_soundex_results[i].fetch('Rank')},#{run.fetch('Probability')},#{@our_results[i].fetch('Probability')}"

		i += 1

	end

	i += 1

	#combined_csv.puts ",,=SUM(C2:C#{i}),=SUM(D2:D#{i}),=AVERAGE(E2:E#{i}),=AVERAGE(F2:F#{i}),=AVERAGE(G2:G#{i}),=AVERAGE(H2:H#{i}),=AVERAGE(I2:I#{i}),=AVERAGE(J2:J#{i})"
	#combined_csv.puts ",,=C#{i+1}/#{i-1}*100,=D#{i+1}/#{i-1}*100"

	combined_csv.close




	combined_csv = File.open("#{@@path}/dropped_ngrams_notfound_results_#{suffix}.csv", "w")

	combined_csv.puts "Orig Query,New Query,Ngrams Found,Ours Found,NGrams Match Rank,Ours Match Rank,Ngrams Rank,Ours Rank,Ngrams Probability,Ours Probability"


	j=0
	i=0
	@ngram_results.each do |run|

		if (run.fetch('Found') == 0) then
			i += 1
			next
		else
			combined_csv.puts "#{run.fetch('Orig Query')},#{run.fetch('New Query')},#{run.fetch('Found')},#{@our_results[i].fetch('Found')},#{run.fetch('Match Rank')},#{@our_results[i].fetch('Match Rank')},#{run.fetch('Rank')},#{@our_results[i].fetch('Rank')},#{run.fetch('Probability')},#{@our_results[i].fetch('Probability')}"
			i += 1
			j += 1
		end


	end

	i += 1
	j += 1

	#combined_csv.puts ",,=SUM(C2:C#{j}),=SUM(D2:D#{j}),=AVERAGE(E2:E#{j}),=AVERAGE(F2:F#{j}),=AVERAGE(G2:G#{j}),=AVERAGE(H2:H#{j}),=AVERAGE(I2:I#{j}),=AVERAGE(J2:J#{j})"

	combined_csv.close

end


# Gathers the statistics for all the runs and outputs them nicely to a file
def statistics

	@out = Hash.new()

	@tests.each do |test|

		total_runs = 0

		ngrams_runs = 0
		four_grams_runs = 0
		dm_soundex_runs = 0
		s_runs = 0

		ngrams_match = 0
		four_grams_match = 0
		dm_soundex_match = 0
		s_match = 0

		ngrams_rank = 0
		four_grams_rank = 0
		dm_soundex_rank = 0
		s_rank = 0

		c_results = File.open("combined_results_#{test[0]}.csv", "r")
		while line = c_results.gets
			line = line.split(",")

			ngrams_match += line[2].to_i
			s_match += line[3].to_i
			four_grams_match += line[4].to_i
			dm_soundex_match += line[5].to_i

			if(line[6] != "-") then 
				ngrams_runs += 1
				ngrams_rank += line[6].to_i 
			end
			if(line[7] != "-") then 
				s_runs += 1
				s_rank += line[7].to_i 
			end
			if(line[8] != "-") then 
				four_grams_runs += 1
				four_grams_rank += line[8].to_i 
			end
			if(line[9] != "-") then 
				dm_soundex_runs += 1
				dm_soundex_rank += line[9].to_i 
			end
			last_line = line

			total_runs += 1
		end

		ngrams_rank = "%.2f" % (ngrams_rank.to_f/(ngrams_runs-1)).to_f
		s_rank = "%.2f" % (s_rank.to_f/(s_runs-1)).to_f
		four_grams_rank = "%.2f" % (four_grams_rank.to_f/(four_grams_runs-1)).to_f
		dm_soundex_rank = "%.2f" % (dm_soundex_rank.to_f/(dm_soundex_runs-1)).to_f

		ngrams_match_percent = "%.2f" % (ngrams_match.to_f/(total_runs-1)*100)
		s_match_percent = "%.2f" % (s_match.to_f/(total_runs-1)*100)
		four_grams_match_percent = "%.2f" % (four_grams_match.to_f/(total_runs-1)*100)
		dm_soundex_match_percent = "%.2f" % (dm_soundex_match.to_f/(total_runs-1)*100)

		s_rank_alt = 0
		i = 0
		n_results = File.open("dropped_ngrams_notfound_results_#{test[0]}.csv", "r")
		while line = n_results.gets
			line = line.split(",")

			if(line[5] != "-") then 
				i += 1
				s_rank_alt += line[5].to_f
			end
		end

		s_rank_alt = "%.2f" % (s_rank_alt/(i-1)).to_f

		type = test[0].split("_")[2]
		sub_type = test[0].split("_")[0] + " " + test[0].split("_")[1]

		output = "* #{sub_type}\n** ngrams found: #{ngrams_match_percent}% (#{ngrams_match}/#{total_runs-1}); rank: #{ngrams_rank}\n** segments found: #{s_match_percent}% (#{s_match}/#{total_runs-1}); rank #{s_rank} & #{s_rank_alt}\n** four grams found: #{four_grams_match_percent}% (#{four_grams_match}/#{total_runs-1}); rank #{four_grams_rank}\n** DM soundex found: #{dm_soundex_match_percent}% (#{dm_soundex_match}/#{total_runs-1}); rank #{dm_soundex_rank}\n\n"

		@out["#{test[1]}"] = output
	end

  puts "OUT:"
  puts @out

	file = File.open('STATS.txt', 'w')

	# output all of the goodness
	if (@out.key?("a1") or @out.key?("a2") or @out.key?("a3") or @out.key?("a4")) then
		file.puts "Add\n\n"

		begin
			if @out.key?("a1") then file.puts @out["a1"] end
			if @out.key?("a2") then file.puts @out["a2"] end
			if @out.key?("a3") then file.puts @out["a3"] end
			if @out.key?("a4") then file.puts @out["a4"] end
		rescue
		end
		file.puts '-'*75
	end
	if (@out.key?("d1") or @out.key?("d2") or @out.key?("d3") or @out.key?("d4")) then
		file.puts "Drop\n\n"

		begin
			if @out.key?("d1") then file.puts @out["d1"] end
			if @out.key?("d2") then file.puts @out["d2"] end
			if @out.key?("d3") then file.puts @out["d3"] end
			if @out.key?("d4") then file.puts @out["d4"] end
		rescue
		end
		file.puts '-'*75
	end


	if (@out.key?("r1") or @out.key?("r2") or @out.key?("r3") or @out.key?("r4")) then
		file.puts "Replace\n\n"

		begin
			if @out.key?("r1") then file.puts @out["r1"] end
			if @out.key?("r2") then file.puts @out["r2"] end
			if @out.key?("r3") then file.puts @out["r3"] end
			if @out.key?("r4") then file.puts @out["r4"] end
		rescue
		end
		file.puts '-'*75
	end


	if (@out.key?("s1") or @out.key?("s2") or @out.key?("s3") or @out.key?("s4")) then
		file.puts "Swap\n\n"

		begin
			if @out.key?("s1") then file.puts @out["s1"] end
			if @out.key?("s2") then file.puts @out["s2"] end
			if @out.key?("s3") then file.puts @out["s3"] end
			if @out.key?("s4") then file.puts @out["s4"] end
		rescue
		end
		file.puts '-'*75
	end

	file.close
end



@correct_queries = Array.new
@mispelled_queries = Array.new

@correct_tables.each do |table|
  results = @ngrams_sql.query('SELECT DISTINCT(query) FROM query_logs_correct;')
  results.each do |result|
    @correct_queries.push(result)
  end

  if @test_type == 'LOGS'
    results = @ngrams_sql.query('SELECT query FROM query_logs_mispelled;')
    results.each do |result|
      @mispelled_queries.push(result)
    end
  end

end

# Remove duplicates and shuffle
if @test_type == 'RAND'
  @correct_queries.uniq!
  @correct_queries.shuffle!
end

MULTIPLIER = 10 # Multiply the 10% by this much.  Ie, I want to do 10% * MULTIPLIET runs.
CUTOFF = 60 # When a result is ranked greated than this, its marked as not found.
TOTAL = (@correct_queries.length) - 1
puts TOTAL
puts TOTAL * 0.1
TEN_PERCENT = (TOTAL * 0.1).to_f


@remaining_tests = 0



def setup

  case @test_type
    when "RAND" then
      @tests = Hash[
        "1_char_drop", "d1", 
        "2_char_drop", "d2", 
        "3_char_drop", "d3", 
        "4_char_drop", "d4", 
        "1_char_add", "a1", 
        "2_char_add", "a2", 
        "3_char_add", "a3", 
        "4_char_add", "a4", 
        "1_char_replace", "r1",
        "2_char_replace", "r2",
        "3_char_replace", "r3",
        "4_char_replace", "r4",
        "Adj_char_swap", "s1",
        "2_char_swap", "s2",
        "3_char_swap", "s3",
        "4_char_swap", "s4"
        ]
    when "LOGS" then
      # test from query logs
      @tests = Hash[
        "query_logs_mom", "query_logs_mom",
        "query_logs_alayna", "query_logs_alayna",
        "query_logs_jay", "query_logs_jay",
        "query_logs_dave", "query_logs_dave",
        "query_logs_chelsey", "query_logs_chelsey"
      ]
  end

	@remaining_tests = @tests.length - 1

	@tests.each do |test|
		main(test[1])
		writeResults(test[0])
		@remaining_tests -= 1
	end

end

setup
statistics
