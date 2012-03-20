class Person

  include ActiveModel::Serializers::JSON
  include ActiveModel::Serializers::Xml

  attr_accessor :attributes, :name

  def self.authenticate(name)
    raise(StandardError, "Invalid User") unless name.match(/admin|user/)
  end

  def initialize(attributes={})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    @attributes = attributes
  end

  def admin?
    name =~ /admin/i
  end

end