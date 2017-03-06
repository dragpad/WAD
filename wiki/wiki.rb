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

#------------------------------------------------
# Defining method to read files.
#------------------------------------------------
def readFile(filename)
    info = ""
    file = File.open(filename)
    file.each do |line|
        info = info + line
    end
    file.close
    $myinfo = info
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
    info = "Hello there!"
    len = info.length
    len1 = len
    readFile("wiki.txt")
    # 'Readfile' changes the value of 'info'.
    @info = info + "" + $myinfo # '$myinfo' defined at the begining.
    len = @info.length
    len2 = len - 1 # -1 to take out the space?
    len3 = len2 - len1 # len3 is lenghth without Hello there?
    @words = len3.to_s # 'words' is the number of characters, not words.
    
    erb :home
    
end

get'/about' do
    erb :about
end

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

get '/logout' do
    $credentials = [' ',' ']
    redirect '/'
end

get '/noaccount' do
    erb :noaccount
end

get '/denied' do
    erb :denied
end


#------------------------------------------------
# Features protected by admin autentification.
#------------------------------------------------

get '/admincontrols' do
    protected!
    @list2 = User.all :order => :id.desc
    erb :admincontrols
end

get '/edit' do
    protected!
    info = ""
    file = File.open("wiki.txt")
    file.each do |line|
        info = info + line
    end
    
    file.close
    @info = info
    erb :edit
end

put '/edit' do
    protected!
    info = "#{params[:message]}"
    @info = info
    file = File.open("wiki.txt", "w") # 'w' changes the file mode to write
    file.puts @info
    file.close
    redirect '/'
end

get '/create' do
    protected!
    erb :create
    
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