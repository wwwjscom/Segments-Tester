#! /usr/bin/env ruby -w

# Queries both engines using a specified test

load "queryToNgramToVote.rb"

########### CONFIG ################
tables = Array['t', 'h', 'o', 'm', 'p']
PATH = Dir.getwd

########## CLEANUP ################
begin
	File.delete("#{PATH}/query_result.txt")
rescue
end


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
		len = self.length
		self[rand(len)] = ""
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
		letter = (rand(26) + 97).chr
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
		letter = (rand(26) + 97).chr
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


def main

	######## MAIN ###########
	queries = Array.new

	tables.each do |table|
		system("mysql -u root --password=root ngrams -e 'SELECT DISTINCT(query) INTO OUTFILE \"#{PATH}/query_result.txt\" FIELDS TERMINATED BY \",\" LINES TERMINATED BY \"\n\" FROM #{table};'")

		query_result = File.open("#{PATH}/query_result.txt")
		while line = query_result.gets
			line.chop!
			queries.push(line)
		end
		File.delete("#{PATH}/query_result.txt")
	end

	# Remove duplicates and shuffle
	queries.uniq!
	queries.shuffle!

	MULTIPLIER = 10
	#MULTIPLIER = 8.92 # runs for 1000 results
	TOTAL = queries.length
	TEN_PERCENT = (TOTAL * 0.1).to_i
	j = 0

	ngram_results = Array.new
	our_results = Array.new

	for i in (0..(TEN_PERCENT*MULTIPLIER).to_i)

		orig_query = queries[i].to_s
		query = String.new(orig_query)
		# Fuck up query
		#query = query.dropChar
		query = query.dropChars(2)
		#query = query.addChar
		#query = query.addChars(2)
		#query = query.replaceChar
		#query = query.replaceChars(2)
		#query = query.swapChar
		#query = query.swapAdjChar

		#puts "Orig: #{orig_query}, new: #{query}"

		if query.length <= 3
			puts "Skipping...Query too short: #{query}"
			next
		end

		# Setup query
		queries_file = File.open("#{PATH}/queries.txt", "w")
		queries_file.puts query	
		queries_file.close

		# Query ngrams engine
		n = Ngrams.new
		n.query

		# Query our engine
		system("php #{PATH}/searchResults.php '#{query}'")	

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
		our_results_file = File.open("#{PATH}/votes/our_results.txt", 'r')

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

		ranking =  "#{match_rank}/#{rank}"
		probability = (match_votes.to_f/total_votes.to_f)*100

		#puts "Probability: #{probability} Query: #{query}" # DEBUG

		#if probability.to_s == "NaN" then puts "-"*200 end # DEBUG

		# Disreguard any finds whos rank is > 40
		if match_rank > 40 then found = 0 end

		# Make the match_rank - if it wasnt found or was too high
		if match_rank > 40 or found == 0 then match_rank = '-' end

		if probability.to_f <= 20 or probability.to_s == "NaN" then
			#puts "Very low probability: #{probability}" # DEBUG
			use_ngrams = true
			our_probability = probability.to_f
			our_result_hash = Hash["Orig Query", orig_query, "New Query", query, "Found", found, "Match Rank", match_rank, "Rank", rank, "Probability", probability]
		else
			result_hash = Hash["Orig Query", orig_query, "New Query", query, "Found", found, "Match Rank", match_rank, "Rank", rank, "Probability", probability]
			our_results.push(result_hash)
		end





		#######################################
		#######################################
		######## NGRAMS ENGINE....GO ##########
		#######################################
		#######################################

		# reset vars
		total_votes = 0
		rank = 1
		found = 0
		match_rank = 0
		probability = 0
		match_votes = 0

		# Read in results of ngrams
		ngram_results_file = File.open("#{PATH}/votes/ngram_results.txt", 'r')

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

		ranking =  "#{match_rank}/#{rank}"
		probability = (match_votes.to_f/total_votes.to_f)*100


		# Disreguard any finds whos rank is > 40
		if match_rank > 40 then found = 0 end

		# Make the match_rank - if it wasnt found or was too high
		if match_rank > 40 or found == 0 then match_rank = '-' end

		result_hash = Hash["Orig Query", orig_query, "New Query", query, "Found", found, "Match Rank", match_rank, "Rank", rank, "Probability", probability]
		ngram_results.push(result_hash)


		if (use_ngrams == true and probability.to_f > our_probability.to_f) or our_probability.to_s == "NaN" then
			#puts "Our new probability is #{probability}" # DEBUG
			result_hash = Hash["Orig Query", orig_query, "New Query", query, "Found", found, "Match Rank", match_rank, "Rank", rank, "Probability", probability]
			our_results.push(result_hash)
			#elsif use_ngrams == true and probability.to_f <= our_probability.to_f then
		elsif use_ngrams == true then
			#puts "ngram probability is #{probability}, sticking with ours of #{our_probability}" # DEBUG
			our_results.push(our_result_hash)
		end

		puts "#{(TEN_PERCENT*MULTIPLIER).to_i - i} runs left"

		#if i >= 2
		#	break
		#end
		j += 1

	end

	puts "Ran #{j} times.\n\n"

end

def writeResults

	combined = Array.new


	our_csv = File.open("#{PATH}/our_results.csv", "w")

	our_csv.puts "Orig Query,New Query,Found,Match Rank,Rank,Probability"


	#puts "-"*50
	our_results.each do |run|
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


	ngrams_csv = File.open("#{PATH}/ngram_results.csv", "w")

	ngrams_csv.puts "Orig Query,New Query,Found,Match Rank,Rank,Probability"


	#puts "-"*50
	ngram_results.each do |run|
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







	combined_csv = File.open("#{PATH}/combined_results.csv", "w")

	combined_csv.puts "Orig Query,New Query,Ngrams Found,Ours Found,NGrams Match Rank,Ours Match Rank,Ngrams Rank,Ours Rank,Ngrams Probability,Ours Probability"


	#puts "-"*50
	i=0
	ngram_results.each do |run|
		#puts "Orig Query: #{run.fetch('Orig Query')}"
		#puts "New Query: #{run.fetch('New Query')}"
		#puts "Found: #{run.fetch('Found')}"
		#puts "Match Rank: #{run.fetch('Match Rank')}"
		#puts "Rank: #{run.fetch('Rank')}"
		#puts "Probability: #{run.fetch('Probability')}"
		#puts "-"*50

		combined_csv.puts "#{run.fetch('Orig Query')},#{run.fetch('New Query')},#{run.fetch('Found')},#{our_results[i].fetch('Found')},#{run.fetch('Match Rank')},#{our_results[i].fetch('Match Rank')},#{run.fetch('Rank')},#{our_results[i].fetch('Rank')},#{run.fetch('Probability')},#{our_results[i].fetch('Probability')}"

		i += 1

	end

	i += 1

	combined_csv.puts ",,=SUM(C2:C#{i}),=SUM(D2:D#{i}),=AVERAGE(E2:E#{i}),=AVERAGE(F2:F#{i}),=AVERAGE(G2:G#{i}),=AVERAGE(H2:H#{i}),=AVERAGE(I2:I#{i}),=AVERAGE(J2:J#{i})"

	combined_csv.close




	combined_csv = File.open("#{PATH}/dropped_ngrams_notfound_results.csv", "w")

	combined_csv.puts "Orig Query,New Query,Ngrams Found,Ours Found,NGrams Match Rank,Ours Match Rank,Ngrams Rank,Ours Rank,Ngrams Probability,Ours Probability"


	j=0
	i=0
	ngram_results.each do |run|

		if (run.fetch('Found') == 0) then
			i += 1
			next
		else
			combined_csv.puts "#{run.fetch('Orig Query')},#{run.fetch('New Query')},#{run.fetch('Found')},#{our_results[i].fetch('Found')},#{run.fetch('Match Rank')},#{our_results[i].fetch('Match Rank')},#{run.fetch('Rank')},#{our_results[i].fetch('Rank')},#{run.fetch('Probability')},#{our_results[i].fetch('Probability')}"
			i += 1
			j += 1
		end


	end

	i += 1
	j += 1

	combined_csv.puts ",,=SUM(C2:C#{j}),=SUM(D2:D#{j}),=AVERAGE(E2:E#{j}),=AVERAGE(F2:F#{j}),=AVERAGE(G2:G#{j}),=AVERAGE(H2:H#{j}),=AVERAGE(I2:I#{j}),=AVERAGE(J2:J#{j})"

	combined_csv.close

end
