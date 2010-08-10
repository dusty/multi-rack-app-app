module MyApp
  # Setup sinatra configuration
  class Base < Sinatra::Base
    
    configure do
      use Rack::Session::Cookie, :secret => 'This is a secret'
      set :raise_errors, false
      set :dump_errors, true
      set :methodoverride, true
      set :show_exceptions, false
      set :static, true
      set :root, Settings.root
    end

    ##
    # These will be available for all MyApp subclasses
    helpers do

      def display_date_time(time)
        if time.is_a?(Time)
          hour = time.strftime("%I").gsub(/^0/,'')
          time.strftime("%m-%d-%Y #{hour}%p")
        end
      end
      
      def display_date(time)
        if time.is_a?(Time)
          hour = time.strftime("%I").gsub(/^0/,'')
          time.strftime("%m-%d-%Y")
        end
      end
      
    end
    
    not_found do
      "Not Found"
    end
    
    error do
      "Error"
    end
    
  end

end