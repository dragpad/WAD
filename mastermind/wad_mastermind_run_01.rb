# Ruby code file - All your code should be located between the comments provided.

# Add any additional gems and global variables here
require 'sinatra'		

# The file where you are to write code to pass the tests must be present in the same folder.
# See http://rspec.codeschool.com/levels/1 for help about RSpec
require "#{File.dirname(__FILE__)}/wad_mastermind_gen_01"

# Main program
module OXs_Game
	@input = STDIN
	@output = STDOUT
	g = Game.new(@input, @output)
	playing = true
	input = ""
	menu = ""
	guess = ""
	secret = "XXXX"
	turn = 0
	win = 0
	game = ""

	@output.puts 'Enter "1" runs game in command-line window or "2" runs it in web browser.'
	game = @input.gets.chomp
	if game == "1"
		puts "Command line game"
	elsif game == "2"
		puts "Web-based game"
	else
		puts "Invalid input! No game selected."
		exit
	end
		
	if game == "1"
		
	# Any code added to command line game should be added below.
		
	g.start()
	g.created_by()
	g.student_id()
	
	g.displaymenu()
	selection = @input.gets.chomp
	
	# menu selection 
	if selection == '1'
		# Setting up the game 
		turns_left = 12
		win = g.clearwinner()
		turn = g.setturn(0)
		g.cleartable()
		secret = g.gensecret("RGBP")
		# Main game loop 
		until (turns_left == 0) || (win == 1) do
			puts "there are #{turns_left} turns left."
			turns_left -= 1
			
			puts "Enter your guess:"
			guess = gets.chomp.upcase
			puts g.checksecret(guess)
			until g.checksecret(guess) == 0 do
				puts "Wrong input, try again:"
				g.getguess
			end
			
		end
	elsif selection == '2'
		g.clearwinner()
		g.setturn(0)
		g.gensecret("RGBP")
		
	elsif selection == '3'
		g.displayanalysis()
		
	elsif selection == '9'
		exit
		
	else
		puts "Wrong Input!"
		exit
		
	end
		
	# Any code added to command line game should be added above.
	
		exit	# Does not allow command-line game to run code below relating to web-based version
	end
end
# End modules

# Sinatra routes

	# Any code added to web-based game should be added below.



	# Any code added to web-based game should be added above.

# End program