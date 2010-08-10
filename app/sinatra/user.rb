class MyApp::UserApp < MyApp::Base
  
  register MyApp::SinatraViewHelpers
  register MyApp::SinatraAuthHelpers
  use Rack::Flash, :sweep => true
  
  configure do
    set :views, "app/views/user"
  end

  before do
    login_required
  end
  
  ##
  # Add helpers only needed in user app here
  helpers do
    
  end
  
  get '/' do
    erb :home
  end
  
  get '/redirect' do
    redirect '/fun'
  end
  
  get '/fun' do
    erb :fun
  end
  
  get '/session' do
    if current_user
      flash[:notice] = "You are logged in."
      redirect '/'
    else
      erb :login
    end
  end

  post '/session' do
    begin
      User.authenticate(params[:password])
      session[:user] = params[:login]
      flash[:notice] = "Login to the User Section was successful"
      redirect_to_stored
    rescue StandardError => e
      flash.now[:warning] = "Login Failed.  #{e.message}"
      erb :login
    end
  end

  get '/logout' do
    session[:user] = nil
    flash[:notice] = "You have been logged out of the User Section"
    redirect '/session'
  end
  
end