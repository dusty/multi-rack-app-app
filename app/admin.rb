class MyApp::AdminApp < MyApp::Base

  register MyApp::SinatraViewHelpers
  register MyApp::SinatraAuthHelpers

  use Rack::Session::Cookie, :secret => 'I am a secret'
  use Rack::Flash, :sweep => true

  configure do
    set :views, "views/admin"
  end

  before do
    admin_required
  end

  helpers do
    def admin_required
      login_required
      unless current_user && current_user.admin?
        flash[:warning] = 'You are not an admin'
        redirect '/'
      end
    end
  end

  ##
  # /admin
  get '/?' do
    erb :home
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