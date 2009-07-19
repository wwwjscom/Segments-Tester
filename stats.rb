#! /usr/local/bin/ruby -w
class Stats

	def initialize()
    puts "Run with -help for help"
		@stat = options('s')
		@file_name = options('f')

		if @stat then

			case @stat
			when 'avg_query_length'
				avg_query_length()
			when 'dataset'
				dataset()
			end

		elsif options('help')!= false then
			help()
		end
	end

	def help()
		puts "-s [option]"
		puts "\tavg_query_length - gives stats for various runs"
		puts "\tdataset - gives stats for the dataset itself\n\t\t-f [filename] - name of the csv file to analyze"
	end

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

	def avg_query_length

		dir = Dir.new('.')

		dir.each do |file|
			if file =~ /combined_results/ then
				f = File.open(file, 'r')
				avg_1 = 0
				avg_2 = 0
				max_orig = 0
				max_new = 0
				while line = f.gets
					line = line.split(',')
					avg_1 = (avg_1 + line[0].length)/2
					avg_2 = (avg_2 + line[1].length)/2
					if max_orig < line[0].length then max_orig = line[0].length end
					if max_new < line[1].length then max_new = line[1].length end
				end

				puts '-'*50
				puts "Run name: #{file[17..-5]}"
				puts "Avg. Query Len. Before: #{avg_1} After: #{avg_2}"
				puts "Max Before: #{max_orig} After: #{max_new}"

			end
		end
		
	end

	def dataset

		f = File.open(@file_name, 'r')

		median_array = Array.new()
		j = 0
		min = 100
		max = 0
		mean = 0
		mode = 0
		median = 0
		std_dev = 0

		while line = f.gets

			j += 1

			line = line.split(',')
			len = line[0].length

			if len < min then min = len end
			if len > max then max = len end

			# median
			median_array.push(len)

			mean = (mean + len)/2

		end

		#####################
		# median
		#####################
		median_array.sort!()
		median = median_array[(median_array.size)/2]

		#####################
		# mode
		#####################
		mode_h = Hash.new
		# setup the mode hash
		median_array.uniq.each do |len|
			mode_h[len] = 0
		end

		# count the occurances
		median_array.each do |len2|
			mode_h[len2] += 1
		end

		# find the mode
		count = 0
		mode_h.each do |key, val|
			if val > count then 
				count = val
				mode = key 
			end
		end


		#####################
		# standard deviation
		#####################
		std_dev_array = median_array
		# find the deviation of each entry
		std_dev_array.each do |entry|
			entry = entry - mean
		end

		# square each entry
		std_dev_array.each do |entry|
			entry = entry**2
		end

		# mean of deviations
		numerator = 0
		std_dev_array.each do |entry|
			numerator += entry
		end
		dev_mean = (numerator / std_dev_array.size)
		#puts dev_mean

		# square root to get the std. dev.
		std_dev = Math.sqrt(dev_mean)


		puts "Min: #{min}"
		puts "Max: #{max}"
		puts "Mean: #{mean}"
		puts "Mode: #{mode}"
		puts "Median: #{median}"
		puts "Std. Dev.: #{std_dev}"
	end

end

s = Stats.new()
