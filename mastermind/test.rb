require 'sinatra'		

require "#{File.dirname(__FILE__)}/wad_mastermind_gen_01"

# Sinatra routes

	# Any code added to web-based game should be added below.

	#class Mastermind_web
	include OXs_Game
	#puts "banana"
	#puts OXs_Game::Game.instance_methods
	@input = 0 
	@output = 0
	g = Game.new(@input,@output)
	playing = true
	input = ""
	menu = ""
	guess = ""
	secret = "XXXX"
	$turn = 0
	win = 0
	game = ""

	#end
	
	get '/' do
	    erb :home
	end
	
	get '/start' do
		erb :start
	end
	
	get '/new' do
		$turns_left = 12
		@win = g.clearwinner()
		@turn = g.setturn(0)
		g.cleartable()
		$table = g.return_table()
		@secret = g.gensecret("RGBP")
        erb :new
    end
    
    post '/new' do
        @guess = params[:guess]
        g.settableturnvalue($turn,@guess)
        #g.checkresult(turn)
        $turns_left -= 1
        $turn += 1
        redirect '/game'
        
    end
    
    get '/game' do
        erb :game
    end
    
    post '/game' do
        @guess = params[:guess]
        #g.checkresult(turn)
        $turns_left -= 1
        redirect '/game'
    end
    
    get '/exit' do
        redirect '/home'
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