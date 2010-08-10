class MyApp::AdminApp < MyApp::Base
  
  register MyApp::SinatraViewHelpers
  register MyApp::SinatraAuthHelpers
  use Rack::Flash, :sweep => true
  
  configure do
    set :views, "app/views/admin"
  end
  
  before do
    login_required
  end
  
  ##
  # Add helpers only needed in admin here
  helpers do
    
    ## Override current_user method to use Admin and session[:admin]
    def current_user
      @current_user ||= Admin.new(session[:admin]) if session[:admin]
    end
          
  end
  
  ##
  # /admin
  get '/?' do
    erb :home
  end
  
  ##
  # /admin/redirect
  #
  # Notice that redirecting to /fun actually redirects to /admin/fun
  get '/redirect' do
    redirect '/fun'
  end
  
  ##
  # /admin/fun
  get '/fun' do
    erb :fun
  end
  
  ##
  # /admin/session
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
      Admin.authenticate(params[:password])
      session[:admin] = params[:login]
      flash[:notice] = "Login to the Admin Section was successful"
      redirect_to_stored
    rescue StandardError => e
      flash.now[:warning] = "Login Failed.  #{e.message}"
      erb :login
    end
  end

  get '/logout' do
    session[:admin] = nil
    flash[:notice] = "You have been logged out of the Admin Section"
    redirect '/session'
  end
  
  ##
  # Serve files in static 
  get %r{^\/(\w+)$} do
    begin
      erb :"static/#{params[:captures].first}"
    rescue Errno::ENOENT
      not_found
    end
  end
  
end