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
			return 0
		end
		# fdihfdrihgedh
		def clearwinner()
		end
		
		# Test 9
		def setturn(turn)
			return turn
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
			if secret.include? "R" or secret.include? "B" or secret.include? "P" or or secret.include? "Y"
				if secret 
			end
		end
		
		def check_valid(secret)
			
		end

		# Any code/methods aimed at passing the RSpect tests should be added above.

	end
end


