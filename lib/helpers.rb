module MyApp

  module SinatraAuthHelpers
    def self.registered(app)
      app.helpers SinatraAuthHelperMethods
    end
  end

  module SinatraViewHelpers
    def self.registered(app)
      app.helpers SinatraViewHelperMethods
    end
  end

  module SinatraApiHelpers
    def self.registered(app)
      app.helpers SinatraApiHelperMethods
    end
  end

  module SinatraApiHelperMethods

    def api_return_codes
      {
        :ok => 200,
        :created => 201,
        :moved => 301,
        :found => 302,
        :bad_request => 400,
        :unauthorized => 401,
        :forbidden => 403,
        :not_found => 404,
        :error => 500
      }
    end

    def json_params
      JSON.parse(request.body.read)
    end

    def format
      @format ||= begin
        case params[:format]
        when 'json' then :json
        when 'xml'  then :xml
        else :html
        end
      end
    end

    def display(object, code=200, location=nil)
      output = case format
      when :json
        content_type :json
        object.to_json if object.respond_to?(:to_json)
      when :xml
        content_type :xml
        object.to_xml if object..respond_to?(:to_xml)
      when :html
        content_type :html
        erb(object.name.downcase) unless object.blank?
      end
      response['Location'] = location if location
      halt(api_return_codes[code] || code, output)
    end

    def respond(code=:ok, args={})
      display("", code, args)
    end

  end

  module SinatraAuthHelperMethods

    def store_location
      session[:return_to] = request.fullpath
    end

    def redirect_to_stored(default='/')
      return_to = session[:return_to] || default
      session[:return_to] = nil
      redirect return_to
    end


    def login_required
      unless request.path_info.match(/^\/session|.*ico/) || current_user
        store_location
        redirect '/session'
      end
    end

    def current_user
      @current_user ||= Person.new(:name => session[:user]) unless session[:user].blank?
    end

  end


  module SinatraViewHelperMethods

    def subdomain
      request.host.split('.')[-3] || nil
    end

    def partial(page, locals={})
      erb(page, {:layout => false}, locals)
    end

    def options_for_select(options,selected=nil)
      output = ""
      options.each do |option|
        select = ""
        select = " selected=\"selected\"" if (selected.to_s == option[1].to_s)
        output += <<-EOD
  <option value="#{option[1]}"#{select}>#{option[0]}</option>\n
        EOD
      end
      output
    end

    def options_for_radio(name,options,selected=nil)
      output = ""
      options.each do |option|
        checked = ""
        checked = "checked=\"checked\"" if (selected.to_s == option.to_s)
        output += <<-EOD
<input type="radio" name="#{name.to_s}" value="#{option.to_s}" #{checked}/>
#{option.to_s.capitalize}<br /> \n
        EOD
      end
      output
    end

    def errors_for(obj,method)
      if error = obj.errors[method].first
        "<span class='error'>#{error}</span>"
      end
    end

  end

end