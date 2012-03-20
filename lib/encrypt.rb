require 'digest/sha1'
class Encrypt
  def self.random_hash
    Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  def self.encrypt(string,salt=nil)
    salt = random_hash if salt == nil || salt.empty?
    Digest::SHA1.hexdigest("--#{salt}--#{string}")
  end

  def self.compare(plain,salt,crypt)
    encrypt(plain,salt) == crypt
  end
end
