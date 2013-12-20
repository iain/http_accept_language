module HttpAcceptLanguage

  class Parser

    attr_accessor :header

    def initialize(header)
      @header = header
    end

    # Returns a sorted array based on user preference in HTTP_ACCEPT_LANGUAGE.
    # Browsers send this HTTP header, so don't think this is holy.
    #
    # Example:
    #
    #   request.user_preferred_languages
    #   # => [ 'nl-NL', 'nl-BE', 'nl', 'en-US', 'en' ]
    #
    def user_preferred_languages
      @user_preferred_languages ||= header.gsub(/\s+/, '').split(/,/).collect do |l|
        l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
          l.split(';q=')
      end.sort do |x,y|
        raise "Not correctly formatted" unless x.first =~ /^[a-z\-0-9]+$/i
        y.last.to_f <=> x.last.to_f
      end.collect do |l|
        l.first.downcase.gsub(/-[a-z0-9]+$/i) { |x| x.upcase }
      end
    rescue # Just rescue anything if the browser messed up badly.
      []
    end

    # Sets the user languages preference, overiding the browser
    #
    def user_preferred_languages=(languages)
      @user_preferred_languages = languages
    end

    # Finds the locale specifically requested by the browser.
    #
    # Example:
    #
    #   request.preferred_language_from I18n.available_locales
    #   # => 'nl'
    #
    def preferred_language_from(array)
      (user_preferred_languages & array.collect { |i| i.to_s }).first
    end

    # Returns the first of the user_preferred_languages that is compatible
    # with the available locales. Ignores region.
    #
    # Example:
    #
    #   request.compatible_language_from I18n.available_locales
    #
    def compatible_language_from(available_languages)
      user_preferred_languages.map do |x| #en-US
        available_languages.find do |y| # en
          y = y.to_s
          x == y || x.split('-', 2).first == y.split('-', 2).first
        end
      end.compact.first
    end

    # Returns a supplied list of available locals without any extra application info
    # that may be attached to the locale for storage in the application.
    #
    # Example:
    # [ja_JP-x1, en-US-x4, en_UK-x5, fr-FR-x3] => [ja-JP, en-US, en-UK, fr-FR]
    #
    def sanitize_available_locales(available_languages)
      available_languages.map do |avail|
        split_locale = avail.split(/[_-]/)

        split_locale.map do |e|
          e unless e.start_with?("x")
        end.compact.join("-")
      end
    end

    # Returns the first of the user preferred languages that is
    # also found in available languages.  Finds best fit by matching on
    # primary language first and secondarily on region.  If no matching region is
    # found, return the first language in the group matching that primary language.
    #
    # Example:
    #
    #   request.language_region_compatible(available_languages)
    #
    def language_region_compatible_from(available_languages)
      available_languages = sanitize_available_locales(available_languages)
      user_preferred_languages.map do |x| #en-US
        lang_group = available_languages.select do |y| # en
          y = y.to_s
          x.split('-', 2).first == y.split('-', 2).first
        end
        lang_group.find{|l| l == x} || lang_group.first #en-US, en-UK
      end.compact.first
    end

  end

end
