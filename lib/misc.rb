require 'iconv'
class Misc
  
  def self.permalink(string)
    string = Iconv.iconv('ascii//translit//IGNORE', 'utf-8', string).to_s
    string.gsub!(/\W+/, ' ') # non-words to space
    string.strip!
    string.downcase!
    string.gsub!(/\s+/, '-') # all spaces to dashes
    string
  end
  
  def self.day_start(time)
    Time.parse("#{time.year}-#{time.month}-#{time.day} 00:00:00")
  end
  
  def self.day_end(time)
    Time.parse("#{time.year}-#{time.month}-#{time.day} 23:59:59")
  end
  
  def self.humanize(string)
    string.to_s.split('_').map{|word| word.capitalize}.join(' ')
  end
  
end