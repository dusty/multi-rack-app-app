require 'yaml'
class Configurator < Hash

  def self.load(file)
    yml = YAML.load_file(file)
    env = ENV['RACK_ENV'] || 'development'
    create(yml['default'] || {}).update(yml[env] || {}).update({'env'=>env})
  end

  def self.create(hash)
    new.update(hash)
  end

  def method_missing(method, *args)
    value = self[method.to_s]
    value.is_a?(Hash) ? self.class.create(value) : value
  end

end
