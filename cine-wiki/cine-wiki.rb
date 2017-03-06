#------------------------------------------------
# Loading gems.
#------------------------------------------------
require 'sinatra'
require 'data_mapper'

# Creating database.
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/wiki.db")

#------------------------------------------------
# Creating database class.
#------------------------------------------------
class User
    include DataMapper::Resource
    property :id, Serial
    property :username, Text, :required => true
    property :password, Text, :required => true
    property :date_joined, DateTime
    property :edit, Boolean, :required => true, :default => false
end

#------------------------------------------------
# Reloading the database.
#------------------------------------------------
DataMapper.finalize.auto_upgrade!

# Defining basic variables.
$myinfo = "Alwin Leene"
@info = ""
@shot_types = ""
@camera_angles = ""

#------------------------------------------------
# Defining method to read files.
#------------------------------------------------
def readFile(filename)
    internal_variable = ""
    file = File.open(filename)
    file.each do |line|
        internal_variable = internal_variable + line
    end
    file.close
    return internal_variable

end

#------------------------------------------------
# Defining methods for word count and character count.
#------------------------------------------------

def word_count(text)
    return text.split.count
end

def character_count(text)
    splitText = text.split
    return splitText.join.length + text.split.count - 1
end

#------------------------------------------------
# Defining log and history entry.
#------------------------------------------------

def log_entry(page_name)
    log_file = File.open("text_files/log.txt", "a")
    log_file.puts(Time.now.to_s + "<br>")
    log_file.puts("Edit to page: " + page_name + "<br>")
    log_file.puts("By User: <b>" + $credentials[0] + "</b>" + "<br>")
    log_file.close
end

def history_entry(page_name,changes)
    log_file = File.open("text_files/history.txt", "a")
    log_file.puts("<b>" + Time.now.to_s + "</b><br>")
    log_file.puts("<b>Edit to page: " + page_name + "</b><br>")
    log_file.puts("<b>By User: " + $credentials[0] + "</b><br>")
    log_file.puts("<b>Changes:</b><br>" + changes + "<br>")
    log_file.puts("<br>")
    log_file.close
end

#------------------------------------------------
# Admin tools.
#------------------------------------------------

get '/admincontrols' do
    protected!
    erb :admincontrols
end

# various buttons for the admin page.
get '/useroptions' do
    protected!
    @list2 = User.all :order => :id.desc
    erb :useroptions
end

# Links to the history and log.
get '/history' do
    protected!
    @history = readFile("text_files/history.txt")
    erb :history
end

get '/log' do
    protected!
    @log = readFile("text_files/log.txt")
    erb :log
end

# Tools and pages to reset the 4 articles.
get '/reset_article' do
    protected!
    erb :reset_article
end

get '/articles/reset_shot_types' do
    protected!
    @ORIGINAL_shot_types = readFile("text_files/ORIGINAL_shot_types.txt")
    file = File.open("text_files/shot_types.txt", "w") # 'w' changes the file mode to write
    file.puts @ORIGINAL_shot_types
    file.close
    log_entry("shot_types_RESET")
    erb :"articles/reset_shot_types"
end

get '/articles/reset_camera_angles' do
    protected!
    @ORIGINAL_camera_angles = readFile("text_files/ORIGINAL_camera_angles.txt")
    file = File.open("text_files/camera_angles.txt", "w") # 'w' changes the file mode to write
    file.puts @ORIGINAL_camera_angles
    file.close
    log_entry("camera_angles_RESET")
    erb :"articles/reset_camera_angles"
end

get '/articles/reset_camera_movements' do
    protected!
    @ORIGINAL_camera_movements = readFile("text_files/ORIGINAL_camera_movements.txt")
    file = File.open("text_files/camera_movements.txt", "w") # 'w' changes the file mode to write
    file.puts @ORIGINAL_camera_movements
    file.close
    log_entry("camera_movements_RESET")
    erb :"articles/reset_camera_movements"
end

get '/articles/reset_effects' do
    protected!
    @ORIGINAL_effects = readFile("text_files/ORIGINAL_effects.txt")
    file = File.open("text_files/effects.txt", "w") # 'w' changes the file mode to write
    file.puts @ORIGINAL_effects
    file.close
    log_entry("camera_effects_RESET")
    erb :"articles/reset_effects"
end

#------------------------------------------------
# Helper to restrict acces to certain pages.
#------------------------------------------------
helpers do
    def protected!
        if authorized?
        return
        end
        redirect '/denied'
    end
    
    def member!
        if loggedin?
        return
        end
        redirect '/deniedaccount'
    end
    
    def loggedin?
        if $credentials != nil
            return true
        else
            return false
        end
    end
    
    # Defining authorisation method: looks for boolean value in database.
    def authorized?
        if $credentials != nil
            @Userz = User.first(:username => $credentials[0])
            if @Userz
                if @Userz.edit == true
                    return true
                else
                    return false
                end
            else
                return false
            end
        end
    end
end

#------------------------------------------------
# Setup for main page
#------------------------------------------------
get '/' do
    erb :home
end

get'/about' do
    erb :about
end

get '/index' do
    erb :index
end

#------------------------------------------------
# 1. Shot type pages
#------------------------------------------------

get'/articles/shot_types' do
    
    @shot_types = readFile("text_files/shot_types.txt")
    @shot_types_words = word_count(@shot_types)
    @shot_types_characters = character_count(@shot_types)
    erb :"articles/shot_types"
end

get '/articles/shot_types_edit' do
    member!
    # If not included the file is reset at every page open
    @shot_types = readFile("text_files/shot_types.txt")

    erb :"articles/shot_types_edit"

end

put '/articles/shot_types_edit' do
    member!
    shot_types = "#{params[:message]}"
    @shot_types = shot_types
    file = File.open("text_files/shot_types.txt", "w") # 'w' changes the file mode to write
    file.puts @shot_types
    file.close
    log_entry("shot_types")
    history_entry("shot_types",shot_types)
    redirect '/articles/shot_types'
end

#------------------------------------------------
# 2. Camera Angles pages
#------------------------------------------------
get'/articles/camera_angles' do
    
    @camera_angles = readFile("text_files/camera_angles.txt")
    @camera_angles_words = word_count(@camera_angles)
    @camera_angles_characters = character_count(@camera_angles)
    erb :"articles/camera_angles"
end

get '/articles/camera_angles_edit' do
    member!
    # If not included the file is reset at every page open
    @camera_angles = readFile("text_files/camera_angles.txt")

    erb :"articles/camera_angles_edit"

end

put '/articles/camera_angles_edit' do
    member!
    camera_angles = "#{params[:message]}"
    @camera_angles = camera_angles
    file = File.open("text_files/camera_angles.txt", "w") # 'w' changes the file mode to write
    file.puts @camera_angles
    file.close
    log_entry("camera_angles")
    history_entry("camera_angles",camera_angles)
    redirect '/articles/camera_angles'
end
#------------------------------------------------
# 3. Camera Movements pages
#------------------------------------------------
get'/articles/camera_movements' do
    
    @camera_movements = readFile("text_files/camera_movements.txt")
    @camera_movements_words = word_count(@camera_movements)
    @camera_movements_characters = character_count(@camera_movements)
    erb :"articles/camera_movements"
end

get '/articles/camera_movements_edit' do
    member!
    # If not included the file is reset at every page open
    @camera_movements = readFile("text_files/camera_movements.txt")

    erb :"articles/camera_movements_edit"

end

put '/articles/camera_movements_edit' do
    member!
    camera_movements = "#{params[:message]}"
    @camera_movements = camera_movements
    file = File.open("text_files/camera_movements.txt", "w") # 'w' changes the file mode to write
    file.puts @camera_movements
    file.close
    log_entry("camera_movements")
    history_entry("camera_movements",camera_movements)
    redirect '/articles/camera_movements'
end
#------------------------------------------------
# 4. Effects pages
#------------------------------------------------
get'/articles/effects' do
    
    @effects = readFile("text_files/effects.txt")
    @effects_words = word_count(@effects)
    @effects_characters = character_count(@effects)
    erb :"articles/effects"
end

get '/articles/effects_edit' do
    member!
    # If not included the file is reset at every page open
    @effects = readFile("text_files/effects.txt")

    erb :"articles/effects_edit"

end

put '/articles/effects_edit' do
    member!
    effects = "#{params[:message]}"
    @effects = effects
    file = File.open("text_files/effects.txt", "w") # 'w' changes the file mode to write
    file.puts @effects
    file.close
    log_entry("effects")
    history_entry("effects",effects)
    redirect '/articles/effects'
end
#------------------------------------------------
# Login pages
#------------------------------------------------

get '/login' do
    erb :login
end

post '/login' do
    $credentials = [params[:username],params[:password]]
    @Users = User.first(:username => $credentials[0])
    if @Users
        if @Users.password == $credentials[1]
            redirect '/'
        else
            $credentials = [' ',' ']
            redirect '/wrongaccount'
        end
    else
        $credentials = [' ',' ']
        redirect '/wrongaccount'
    end
end

get '/wrongaccount' do
    erb :wrongaccount
end

get '/user/:uzer' do
    @Userz = User.first(:username => params[:uzer])
    if @Userz != nil
        erb :profile
    else
        redirect '/noaccount'
    end
end

#------------------------------------------------
# Normal acount create
#------------------------------------------------

get '/createaccount' do
    erb :createaccount
end

post '/createaccount' do
    n = User.new
    n.username = params[:username]
    n.password = params[:password]
    n.date_joined = Time.now
    # If a user is created with this username and password, it will become the admin by default.
    if n.username == "Admin" and n.password == "Password"
        n.edit = true
    end
    n.save
    redirect '/'
end

#------------------------------------------------
# Admin rights acount create
#------------------------------------------------

get '/createadminaccount' do
    erb :createadminaccount
end

post '/createadminaccount' do
    n = User.new
    n.username = params[:username]
    n.password = params[:password]
    n.date_joined = Time.now
    n.edit = true
    n.save
    redirect '/'
end

get '/logout' do
    $credentials = [' ',' ']
    redirect '/'
end

get '/noaccount' do
    erb :noaccount
end

# Displays if uses is not an admin.
get '/denied' do
    erb :denied
end

# Displays if user is not logged in.
get '/deniedaccount' do
    erb :deniedaccount
end


#------------------------------------------------
# Features protected by admin autentification.
#------------------------------------------------

get '/new_article' do
    protected!
    erb :new_article
    
end

put '/user/:uzer' do
    n = User.first(:username => params[:uzer])
    n.edit = params[:edit] ? 1 : 0
    n.save
    redirect '/'
end

# stops the Admin account from being deleted.
get '/user/delete/:uzer' do
    protected!
     n = User.first(:username => params[:uzer])
    if n.username == "Admin"
        erb :denied
    else
        n.destroy
        @list2 = User.all :order => :id.desc
        erb :admincontrols
    end
end

# Changing the name and/or password of an account.
get '/user/changeuser/:uzer' do
    protected!
    $editeuser = User.first(:username => params[:uzer])
    @changeuser = $editeuser.username
    @changepassword = $editeuser.password
    erb :changeuser
end

post '/user/changeuser/:uzer' do
    puts @changeuser
    $editeuser.update(:username => params[:namechange], :password => params[:passchange])
    
    redirect '/admincontrols'
end

#------------------------------------------------
# Runs if a page is not found.
#------------------------------------------------
get '/notfound' do
    erb :notfound
end

not_found do
    status 404
    redirect '/notfound'
end