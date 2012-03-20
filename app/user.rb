class MyApp::UserApp < MyApp::Base

  register MyApp::SinatraViewHelpers
  register MyApp::SinatraAuthHelpers

  use Rack::Session::Cookie, :secret => 'I am a secret'
  use Rack::Flash, :sweep => true

  configure do
    set :views, "views/user"
  end

  before do
    login_required
  end

  # Add helpers only needed in user app here
  helpers do
  end

  get '/' do
    erb :home
  end

  get '/session' do
    if current_user
      flash[:notice] = "You are logged in"
      redirect '/'
    else
      erb :login
    end
  end

  post '/session' do
    begin
      Person.authenticate(params[:login])
      session[:user] = params[:login]
      flash[:notice] = "Login was successful"
      redirect_to_stored
    rescue StandardError => e
      flash.now[:warning] = "Login failed: #{e.message}"
      erb :login
    end
  end

  get '/logout' do
    session[:user] = nil
    flash[:notice] = "You have been logged out"
    redirect '/session'
  end

end