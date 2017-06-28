module HttpAcceptLanguage
  module Matcher
    class RegistrationError < StandardError; end

    class << self
      def match(available_languages, preferred)
        register_included_matchers if @matchers.nil?
        klass = @matchers[language_tag(preferred)] || default_matcher
        klass.new(available_languages).match(preferred)
      end

      def register(matcher, replace = false)
        register_included_matchers if @matchers.nil?
        register_matcher(matcher, replace)
      end

      private

      def register_included_matchers
        @matchers = {}
        get_included_matchers.each { |m| register_matcher(m) }
      end

      def get_included_matchers
        Dir.glob(File.dirname(__FILE__) + '/matcher/*.rb') { |f| require f }
        HttpAcceptLanguage::Matcher.constants.map { |c| HttpAcceptLanguage::Matcher.const_get(c) }
      end

      def register_matcher(klass, replace = false)
        return unless klass.is_a?(Class) && klass.respond_to?(:matching_languages)
        klass.matching_languages.each do |lang|
          lang = lang.downcase.to_sym
          raise RegistrationError.new("A matcher for #{lang} already exists") if !replace && @matchers[lang]
          @matchers[lang] = klass
        end
      end

      def language_tag(language)
        language.downcase.split('-', 2).first.to_sym
      end

      def default_matcher
        HttpAcceptLanguage::Matcher::DefaultLanguageMatcher
      end
    end
  end
end
