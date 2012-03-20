class MyApp::ApiApp < MyApp::Base

  register MyApp::SinatraApiHelpers

  before do
    login_required
  end

  configure do
    set :views, "views/api"
  end

  error do
    respond(:error)
  end

  not_found do
    respond(:not_found)
  end

  helpers do

    # Log in the client by the params[:token]
    def login_required
      respond(:unauthorized) unless params[:token] == "VENDOR"
    end

  end

  ##
  # Displays the monkeys
  #
  # /api/monkeys?token=VENDOR&format=json
  get '/monkeys', :provides => [:xml, :json] do
    monkeys = [
      {:name => "bob", :age => 3},
      {:name => "sally", :age => 7}
    ]
    display(monkeys)
  end

end