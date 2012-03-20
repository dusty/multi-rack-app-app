class String
  def slugize
    self.strip.downcase.gsub(/&/, 'and').gsub(/\s+/, '-').gsub(/[^a-z0-9-]/, '')
  end
end

class Fixnum
  def ordinal
    ActiveSupport::Inflector.ordinalize(self)
  end
end

class Date
  unless respond_to? :iso8601
    def iso8601
      ::Time.utc(year, month, day, 0, 0, 0, 0).iso8601
    end
  end
end

