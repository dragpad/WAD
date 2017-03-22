# Ruby code file - All your code should be located between the comments provided.

# Main class module
module OXs_Game
	# Input and output constants processed by subprocesses. MUST NOT change.
	GOES = 12
	COLOURS = "RGBP"

	class Game
		attr_reader :table, :input, :output, :turn, :turnsleft, :winner, :secret, :score, :resulta, :resultb, :guess
		attr_writer :table, :input, :output, :turn, :turnsleft, :winner, :secret, :score, :resulta, :resultb, :guess
		
		def initialize(input, output)
			@input = input
			@output = output
		end
		
		def getguess
			guess = @input.gets.chomp.upcase
		end
		
		# Any code/methods aimed at passing the RSpect tests should be added below.
		
		# Test 1 and 4 and 5 and 6
		def start()
			@output.puts("Welcome to Mastermind!")
			@output.puts("Created by: #{created_by} (#{student_id})")
			@output.puts("Starting game...")
			@output.puts('Enter "1" to run the game in the command-line window or "2" to run it in a web browser')
		end
		
		# Test 2
		def created_by()
			return "Alwin Leene"
		end
		
		# Test 3
		def student_id()
			return 51657004
		end
		
		# Test 7
		def displaymenu()
			@output.puts("Menu: (1) Start | (2) New | (3) Analysis | (9) Exit")
		end
		
		# Test 8
		def winner()
			if @resulta == []
				return 0
			elsif (@resulta[@turn]) == 4
				puts "You win!"
				return 1
			else
				return 0
			end
		end
		
		def clearwinner()
			@resulta = []
			@resultb = []
			return 0
		end
		
		# Test 9
		def setturn(turn)
			@turn = turn
			return @turn
		end
		
		def turn()
			return 0
		end
		
		# Test 10
		def setturnsleft(goes)
			return goes
		end
		
		def turnsleft()
			return 12
		end
		
		# Test 11
		def checksecret(secret)
			good_characters = ['R','P','B','G']
			character_test = 0
			secret = secret.split("")
			for character in secret do
				if secret.length != 4
					character_test = 1
					break
				elsif good_characters.include? character
					character_test = 0
				else
					character_test = 1
					break
				end
			end
			return character_test
		end
		
		# Test 12
		def gensecret(array)
			valid_characters = array.split("")
			secret = ""
			4.times {secret << valid_characters[rand(0..3)]}
			@secret = secret
			return secret
		end
		
		# Test 13
		@secret = ""
		def setsecret(thing)
			@secret = thing
		end
		
		# Test 14
		def getsecret()
			return @secret
		end
		
		# Test 15
		def displaysecret
			@output.puts("Secret state: #{@secret}")
		end
		
		# Test 16
		def cleartable()
			@table = ["____","____","____","____","____","____","____","____","____","____","____","____"]
			@resulta = []
			@resultb = []
		end
		
		# Test 17
		def gettableturnvalue(turn)
			return @table[turn]
		end
		
		# Test 18
		def settableturnvalue(turn,  value)
			@table[turn] = value
			@turn = turn
		end
		
		# Test 19
		def displaytable()
			#puts("TURN | XXXX | SCORE\n===================\n  1. | #{@table[@turn]} |\n  2. | ____ |\n  3. | ____ |\n  4. | ____ |\n  5. | ____ |\n  6. | ____ |\n  7. | ____ |\n  8. | ____ |\n  9. | ____ |\n 10. | ____ |\n 11. | ____ |\n 12. | ____ |\n\n")
			
			count = []
			thing = 0
			(@turn + 1).times do
				count[thing] = thing + 1
				thing += 1
			end
			output_string = ""
			
			output_string << "TURN | XXXX | SCORE\n===================\n"
			
			@table.zip(count).each do |item, number|
				if number != nil
					if number < 10
						output_string << "  #{number}. | #{item} |\n"
					else
						output_string << " #{number}. | #{item} |\n"
					end
				else
					break
				end
			end
			
			
			empty_count = @turn + 1
			(11 - @turn).times do
				if empty_count >= 9
					output_string << " #{empty_count + 1}. | ____ |\n"
				else
					output_string << "  #{empty_count + 1}. | ____ |\n"
				end
				empty_count += 1
			end
			
			output_string << "\n"
			
			@output.puts output_string
			
		end
		
		# Test 20
		def finish()
			@output.puts("...finished game")
		end
		
		# Test 21
		def checkresult(turn)
			color_score = 0
			placement_score = 0
			secret = @secret.to_s.split("")
			guess = @table[turn].to_s.split("")
			
			gR = 0
			gB = 0
			gG = 0
			gP = 0
			for thing in guess do
				if thing == "R"
					gR += 1
				elsif thing == "B"
					gB += 1
				elsif thing == "G"
					gG += 1
				elsif thing == "P"
					gP += 1
				end
			end
			
			sR = 0
			sB = 0
			sG = 0
			sP = 0
			for stuff in secret do
				if stuff == "R"
					sR += 1
				elsif stuff == "B"
					sB += 1
				elsif stuff == "G"
					sG += 1
				elsif stuff == "P"
					sP += 1
				end
			end
			
			def compare_score(secretColor, guessColor)
				color_score = 0
				begin
					if (guessColor/secretColor) >= 1
						color_score += secretColor
					else
						color_score += (guessColor/secretColor) * secretColor
					end
					return color_score
				rescue
					return 0
				end
			end
			
			color_score += compare_score(sR,gR)
			color_score += compare_score(sB,gB)
			color_score += compare_score(sG,gG)
			color_score += compare_score(sP,gP)
			
			place = 0
			for item in guess do
				if item == secret[place]
					placement_score += 1
				end
				place += 1
			end

			color_score -= placement_score
			
			@resulta[turn] = placement_score
			
			@resultb[turn] = color_score

			@output.puts("Result #{placement_score}:#{color_score}")
		end
		
		# Test 22
		def displayanalysis()
			
			if @turn == nil
				@turn = 0
			end
			
			count = []
			thing = 0
			(@turn + 1).times do
				count[thing] = thing + 1
				thing += 1
			end
			
			output_string = ""
			
			output_string << "TURN | XXXX | SCORE\n===================\n"
			
			if @table == nil
				@table = ["____","____","____","____","____","____","____","____","____","____","____","____"]
			end
			
			if @resulta == nil
				@resulta = []
			end
			
			if @resultb == nil
				@resultb = []
			end
			
			@table.zip(count).each do |item, number|
				if number != nil
					if number < 10
						output_string << "  #{number}. | #{item} | #{@resulta[number - 1]}:#{@resultb[number - 1]}\n"
					else
						output_string << " #{number}. | #{item} | #{@resulta[number - 1]}:#{@resultb[number - 1]}\n"
					end
				else
					break
				end
			end
			
			
			empty_count = @turn + 1
			(11 - @turn).times do
				if empty_count >= 9
					output_string << " #{empty_count + 1}. | ____ | 0:0\n"
				else
					output_string << "  #{empty_count + 1}. | ____ | 0:0\n"
				end
				empty_count += 1
			end
			
			output_string << "\n"
			
			@output.puts output_string
						
		end

		# Test 23
		def revealtable()
			@output.puts("TURN | #{@secret} | SCORE\n===================\n  1. | ____ |\n  2. | ____ |\n  3. | ____ |\n  4. | ____ |\n  5. | ____ |\n  6. | ____ |\n  7. | ____ |\n  8. | ____ |\n  9. | ____ |\n 10. | ____ |\n 11. | ____ |\n 12. | ____ |\n\n")
		end
		
		# Backup
		
		def backup()
			begin
				backup = File.open("backup.txt","w")
				backup.puts("#{@turn + 1}")
				backup.puts("#{@secret}")
				backup.puts("#{@resulta.join(",")}")
				backup.puts("#{@resultb.join(",")}")
				backup.puts("#{@table.join(",")}")
				backup.close
			ensure
				backup = File.new("backup.txt","w")
				backup.puts("#{@turn + 1}")
				backup.puts("#{@secret}")
				backup.puts("#{@resulta.join(",")}")
				backup.puts("#{@resultb.join(",")}")
				backup.puts("#{@table.join(",")}")
				backup.close
			end
		end
		
		def readBackup()
			backup = File.open("backup.txt","r")
			backup_content = []
			
			backup.each do |line|
		        backup_content.push(line)
		    end
		    
		    @turn = (backup_content[0]).to_i
		    
		    @secret = backup_content[1]
		    
		    @resulta = (backup_content[2]).split(",")
		    resulta = []
		    for item in @resulta do
		    	item = item.to_i
		    	resulta.push(item)
		    end
		    @resulta = resulta
		    print @resulta[-1]
		    
		    @resultb = (backup_content[3]).split(",")
		    resultb =[]
		    for item in @resultb do
		    	item = item.to_i
		    	resultb.push(item)
		    end
		    @resultb = resultb
		    
		    @table = (backup_content[4]).split(",")
		    backup.close
		end
		
		def return_turn()
			return @turn
		end
		
		def return_table()
			return @table
		end
		
		# Any code/methods aimed at passing the RSpect tests should be added above.

	end
end


