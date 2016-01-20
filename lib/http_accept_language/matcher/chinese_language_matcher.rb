module HttpAcceptLanguage
  module Matcher
    class ChineseLanguageMatcher
      def self.matching_languages
        %w(zh yue cmn)
      end

      def initialize(available_languages)
        @available_languages = available_languages
      end

      def match(preferred)
        preferred = preferred.downcase

        # 1. Try an exact match (e.g. "zh-TW" or "zh-Hans" or "zh-Hant-HK")
        match = @available_languages.find { |lang| lang.downcase == preferred }

        # 2. If no exact match, try to find an available language matching the
        # (explicit or implied) script code
        match ||= script_match(preferred)

        # May be nil if the matcher was unable to find a suitable match
        match
      end

      private

      def script_match(preferred)
        # Determine the script code (explicit or implied) of the preferred language
        preferred_script = script_for_language(preferred)
        return nil unless preferred_script

        # Find all available languages with the same script code as the preferred language
        matching_languages = available_languages_for_script[preferred_script] || []

        match = nil

        # If the preferred language includes a region code, first try to match an
        # available language with the same script and region codes
        preferred_region = region_part(preferred)
        match ||= matching_languages.find { |lang| preferred_region == region_part(lang) } if preferred_region

        # Next try to match an available language with the preferred language's
        # script code and the "default" region code for that script ("CN" for
        # "Hans", "TW" for "Hant")
        match ||= matching_languages.find { |lang| %w(cn tw).include?(region_part(lang)) }

        # If a language with the "default" region code for that script code is
        # not available, try to match any language with that script code
        match ||= matching_languages.first

        # May be nil if no available languages with matching scripts exist
        match
      end

      def available_languages_for_script
        if @script_map.nil?
          @script_map = {}
          @available_languages.each do |lang|
            next unless self.class.matching_languages.include?(language_part(lang))
            script = script_for_language(lang.downcase)
            if script
              @script_map[script] ||= []
              @script_map[script] << lang
            end
          end
        end

        @script_map
      end

      def script_for_language(language)
        codes = language.split('-', 4)

        # Standardize internal representation on (lang, script, region)
        if codes[0] == 'zh' && codes[1] == 'cmn' # zh-cmn-Hans-CN => zh-Hans-CN
          codes.delete_at(1)
        elsif codes[0] == 'cmn' # cmn-Hans-CN => zh-Hans-CN
          codes[0] = 'zh'
        elsif codes[0] == 'zh' && codes[1] == 'yue' # zh-yue-Hant-HK => yue-Hant-HK
          codes.delete_at(0)
        end

        # Use the included script identifier if it exists
        script = codes.find { |code| %w(hans hant).include?(code) }

        # 'yue' language always implies 'hant'
        script ||= 'hant' if codes[0] == 'yue'

        # 'zh' language requires region lookup
        script ||= script_for_region(codes[1])

        # May be nil if only 'zh' was supplied or if it was supplied with an
        # unknown region tag (e.g. 'zh-US') - in both cases, we are unable to
        # determine the appropriate script code
        script
      end

      def language_part(language)
        language.split('-', 2).first.to_s.downcase
      end

      def region_part(language)
        region = language.split('-', 4).last
        region.length == 2 ? region.downcase : nil
      end

      def script_for_region(region)
        if %w(cn sg).include?(region)
          'hans'
        elsif %w(tw hk mo).include?(region)
          'hant'
        end
      end
    end
  end
end
