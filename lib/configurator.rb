require 'yaml'
##
# Configurator
#
# Add dot-notation to finding the keys in a hash
# Requires all keys to be symbols
class Configurator < Hash
  
  def self.root
    @root ||= File.expand_path(File.join(File.dirname(__FILE__), '..'))
  end
  
  def self.env
    @env ||= (ENV['RACK_ENV'] ? ENV['RACK_ENV'] : 'development')
  end
  
  def self.defaults
    { 'root' => root, 'env'  => env }
  end
  
  def self.config
    if File.exists?("#{root}/config/settings.yml")
      "#{root}/config/settings.yml"
    else
      "#{root}/config/settings.yml.local"
    end
  end
  
  def self.load
    create(YAML.load_file(config)[env]).update(defaults)
  end
  
  def self.create(hash)
    new.update(hash)
  end
  
  def method_missing(method, *args)
    value = self[method.to_s]
    value.is_a?(Hash) ? self.class.create(value) : value
  end
  
end