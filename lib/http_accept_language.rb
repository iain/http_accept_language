module HttpAcceptLanguage
  # Returns a sorted array based on user preference in HTTP_ACCEPT_LANGUAGE.
  # Browsers send this HTTP header. Don't think this is holy.
  def user_preferred_languages
    @user_preferred_languages ||= env['HTTP_ACCEPT_LANGUAGE'].split(',').collect do |l|
      l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
      l.split(';q=')
    end.sort do |x,y|
      raise "Not correctly formatted" unless x.first =~ /^[a-z\-]+$/i
      y.last.to_f <=> x.last.to_f
    end.collect do |l|
      l.first.downcase.gsub(/-[a-z]+$/i){|x| x.upcase} 
    end
  rescue
    []
  end
  def preferred_language_from(array)
    (user_preferred_languages & array).first
  end
  
  def compatible_language_from(array)
    array.select{|x| lang = x.split("-")[0]; user_preferred_languages.any?{|y| y.split("-")[0] == lang }}.first
  end
  
  
end
