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
    
    def display(object, code=:ok, args={})
      case response.content_type
      when 'application/json'
        content_type :json
        output = object.to_json
      when 'application/xml'
        content_type :xml
        output = object.to_xml
      else
        output = object.to_yaml
      end
      return_code = api_return_codes[code] || 500
      response['Location'] = args[:location] if args[:location]
      halt(return_code, output)
    end
    
    def respond(code=:ok, args={})
      display("", code, args)
    end
    
  end
  
  module SinatraAuthHelperMethods
    
    ##
    # Store the requested path.  Storing the relative URL
    # in case the redirect option is prepended above.
    def store_location
      unless request.path_info.match(/^\/session/)
        return_to = request.path_info
        unless request.query_string.empty?
          return_to += "?#{request.query_string}"
        end
        session[:return_to] = return_to
      end
    end

    ##
    # Redirect to the stored path or a default
    def redirect_to_stored(default='/')
      return_to = session[:return_to] || default
      session[:return_to] = nil
      redirect return_to
    end
    
    def login_required
      return true if request.path_info.match(/^\/session|.*ico/) || current_user
      store_location
      redirect '/session'
    end
    
    def current_user
      @current_user ||= User.new(session[:user]) if session[:user]
    end
    
  end
  
  
  module SinatraViewHelperMethods

    ##
    # The current subdomain
    def subdomain
      request.host.split('.')[-3] || nil
    end
      
    ##
    # Automatically detect a URLMapped Rack application and
    # prepend the correct prefix before sending the redirect
    def redirect(location, *args)
      unless request.path == request.path_info
        path = request.path.split('/')
        info = request.path_info.split('/')
        prefix = (path - info).join('/')
        location = File.join('/', prefix, location)
      end
      super(location, *args)
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
    
    def error_messages_for(model)
      return "" if model.errors.empty?
      out = '<ul class="errors">'
      model.errors.each do |error|
        out += <<-EOD
<li class="error">#{Misc.humanize(error[0])}: #{error[1].last}</li>
        EOD
      end
      out += '</ul>'
    end
      
    def throw_content(location, &block)
      @_content_blocks ||= {}
      @_content_blocks[location] ||= erb_with_output_buffer { block.call }
    end

    def content_for(location)
      @_content_blocks ||= {}
      @_content_blocks[location]
    end

    def erb_with_output_buffer(buf='')
      @_out_buf, old_buffer = buf, @_out_buf
      yield
      @_out_buf
    ensure
      @_out_buf = old_buffer
    end

  end
  
end