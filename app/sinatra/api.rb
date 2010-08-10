class MyApp::ApiApp < MyApp::Base
  
  register MyApp::SinatraApiHelpers
  
  before do
    login_required
    set_response_format
  end

  configure do
    set :views, "app/views/api"
  end

  error do
    respond(:error)
  end
  
  not_found do
    respond(:not_found)
  end
    
  helpers do
    
    ##
    # If the client cannot send an Accept header, we can use
    # params[:format] to achieve the same effect
    def set_response_format
      case params[:format]
      when 'xml'
        request.env["HTTP_ACCEPT"] = 'application/xml'
      when 'json'
        request.env["HTTP_ACCEPT"] = 'application/json'
      end
    end
    
    ##
    # Log in the client by the params[:token]
    def login_required
      respond(:unauthorized) if (params[:token].nil? || params[:token].empty?)
      begin
        Vendor.authenticate(params[:token])
      rescue StandardError => e
        respond(:unauthorized)
      end
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