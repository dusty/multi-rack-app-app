class Person
  
  PASSWORD=nil
  
  attr_reader :name
  
  def initialize(name)
    @name = name
  end
  
  def self.authenticate(password)
    (password == self::PASSWORD) || raise(StandardError, "Invalid Password")
  end
  
end