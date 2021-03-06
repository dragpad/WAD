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
	
	until playing == false do
		g.displaymenu()
		selection = @input.gets.chomp
		
		# Menu selection.
		# Start.
		if selection == '1'
			
			g.readBackup()
			turn = g.return_turn()
			turns_left = 12 - turn
			
			
			# Main game loop.
			until (turns_left == 0) || (win == 1) do
				puts "there are #{turns_left} turns left."
				turns_left -= 1
				
				# Print current table.
				g.displaytable()
				
				# Enter guess and checks if the guess is valid.
				puts "Enter your guess:"
				guess = gets.chomp.upcase
				until g.checksecret(guess) == 0 do
					puts "Wrong input, try again:"
					guess = gets.chomp.upcase
				end
				
				# Append guess to table.
				g.settableturnvalue(turn,guess)
				
				# Check result of the round.
				g.checkresult(turn)
				
				# Chech score.
				win = g.winner()
				
				# Change turn count.
				turn += 1
				
				g.backup()
			end
			
			if turns_left == 0 && win ==0
				puts "You Lost :'("
			end
			
		# New.
		elsif selection == '2'
		
			# Setting up the game.
			turns_left = 12
			win = g.clearwinner()
			turn = g.setturn(0)
			g.cleartable()
			secret = g.gensecret("RGBP")

			
			# Main game loop.
			until (turns_left == 0) || (win == 1) do
				puts "there are #{turns_left} turns left."
				turns_left -= 1
				
				# Print current table.
				g.displaytable()
				
				# Enter guess and checks if the guess is valid.
				puts "Enter your guess:"
				guess = gets.chomp.upcase
				until g.checksecret(guess) == 0 do
					puts "Wrong input, try again:"
					guess = gets.chomp.upcase
				end
				
				# Append guess to table.
				g.settableturnvalue(turn,guess)
				
				# Check result of the round.
				g.checkresult(turn)
				
				# Chech score.
				win = g.winner()
				
				# Change turn count.
				turn += 1
				
				g.backup()
			end
			
			if turns_left == 0 && win ==0
				puts "You Lost :'("
			end
			
		# Analysis.
		elsif selection == '3'
			g.readBackup()
			g.displayanalysis()
			
		# Exit.
		elsif selection == '9'
			playing = false
			puts "...finished game."
			
		else
			puts "Wrong Input!"
			exit
			
		end
	end
		
	# Any code added to command line game should be added above.
	
		exit	# Does not allow command-line game to run code below relating to web-based version
	end
end
# End modules

# Sinatra routes

	# Any code added to web-based game should be added below.

	#class Mastermind_web
	include OXs_Game
	#puts "banana"
	#puts OXs_Game::Game.instance_methods
	@input = 0 
	@output = 0
	g = Game.new(@input,@output)
	$turn = 0

	#end
	
	get '/' do
	    erb :home
	end
	
	get '/start' do
	    g.readBackup_web()
	    $turn = g.return_turn()
		$turns_left = 12 - $turn
        $table = g.return_table()
        $win = g.clearwinner()
        @lastTurna = g.return_resultaList()
        @lastTurnb = g.return_resultbList()
		erb :start
	end
	
	post '/start' do
        if ($turns_left == 1)
            redirect '/lost'
        else
            @guess = params[:guess].upcase
            if g.checksecret(@guess) == 1
                $wrong = 1
                redirect '/game'
            else
                g.settableturnvalue($turn,@guess)
                g.checkresult_web($turn)
                if g.return_resulta() == 4
                    redirect '/win'
                end
                $turns_left -= 1
                $turn += 1
                g.backup_web()
                redirect '/game'
            end
        end
    end
	
	get '/new' do
		$turns_left = 12
		$win = g.clearwinner()
		$turn = g.setturn(0)
		g.cleartable()
		$table = g.return_table()
		@secret = g.gensecret("RGBP")
        erb :new
    end
    
    post '/new' do
        @guess = params[:guess].upcase
        if g.checksecret(@guess) == 1
            $wrong = 1
            redirect '/game'
        else
            g.settableturnvalue($turn,@guess)
            g.checkresult_web($turn)
            #g.checkresult(turn)
            $turns_left -= 1
            $turn += 1
            g.backup_web()
            redirect '/game'
        end
    end
    
    get '/game' do
        @resulta = g.return_resulta()
        @resultb = g.return_resultb()
        erb :game
    end
    
    post '/game' do
        if ($turns_left == 1)
            redirect '/lost'
        else
            @guess = params[:guess].upcase
            if g.checksecret(@guess) == 1
                $wrong = 1
                redirect '/game'
            else
                g.settableturnvalue($turn,@guess)
                g.checkresult_web($turn)
                if g.return_resulta() == 4
                    redirect '/win'
                end
                $turns_left -= 1
                $turn += 1
                g.backup_web()
                $wrong = 0
                redirect '/game'
            end
        end
    end
    
    get '/analysis' do
        g.readBackup_web()
        $table = g.return_table()
        @resultaList = g.return_resultaList()
        @resultbList = g.return_resultbList()
        erb :analysis
    end
    
    get '/lost' do
        erb :lost
    end
    
    get '/win' do
        erb :win
    end
    
	
	get '/notfound' do
		erb :notfound
	end
	
	not_found do
		status 404
		redirect '/notfound'
	end

	# Any code added to web-based game should be added above.
	
# End program