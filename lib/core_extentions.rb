class Hash  
  def to_url_params  
    elements = []  
    self.each_pair do |key, value|  
      elements << param_for(key, value).flatten  
    end  
    elements.join('&')  
  end  
  
  private  
  def param_for(key, value, parent = nil)  
    if value.is_a?(Hash)  
      temp = []  
      value.each_pair do |key2, value2|  
        temp << param_for(key2, value2, parent ? parent + "[#{key}]" : key.to_s)  
      end  
      return temp  
    else  
      return ["#{parent ? parent + "[#{key}]" : key.to_s}=#{value}"]  
    end  
  end  
end


class Time
  def round(seconds = 60)
    Time.at((self.to_f / seconds).round * seconds)
  end

  def floor(seconds = 60)
    Time.at((self.to_f / seconds).floor * seconds)
  end
  
  def ceil(seconds = 60)
    Time.at((self.to_f / seconds).ceil * seconds)
  end
end
