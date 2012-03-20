class Validator

  def self.suffix
    /([A-Z0-9.-]+\.[A-Z]{2,4})/i
  end

  def self.email
    /([A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4})/i
  end

  def self.phone
    /1?\D*([2-9][0-8]\d)\D*([2-9]\d{2})\D*(\d{4})/
  end

  def self.normalize_phone(_phone)
    if match = phone.match(_phone).captures.join('') rescue nil
      match.match(/^1/) ? match : "1#{match}"
    end
  end

  def self.normalize_email(_email)
    email.match(_email).captures.join('').downcase rescue nil
  end

  def self.normalize_suffix(_suffix)
    suffix.match(_suffix).captures.join('').downcase rescue nil
  end

  def self.valid_email?(_email)
    !!(email =~ _email)
  end

  def self.valid_phone?(_phone)
    !!(phone =~ _phone)
  end

end
