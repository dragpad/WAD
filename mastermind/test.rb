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
	    g.readBackup_web()
	    $turn = g.return_turn()
		$turns_left = 12 - $turn
        $table = g.return_table()
        $win = g.clearwinner()
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