module HttpAcceptLanguage
  module Matcher
    class DefaultLanguageMatcher
      def initialize(available_languages)
        @available_languages = available_languages
      end

      def match(preferred)
        preferred = preferred.downcase
        preferred_language = preferred.split('-', 2).first

        lang_group = @available_languages.select do |available| # en
          preferred_language == available.downcase.split('-', 2).first
        end

        lang_group.find { |lang| lang.downcase == preferred } || lang_group.first #en-US, en-UK
      end
    end
  end
end
