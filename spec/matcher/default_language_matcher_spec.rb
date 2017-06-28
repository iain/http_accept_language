require 'http_accept_language/matcher/default_language_matcher'

describe HttpAcceptLanguage::Matcher::DefaultLanguageMatcher do
  let(:matcher) { HttpAcceptLanguage::Matcher::DefaultLanguageMatcher.new(available) }

  context "when the available languages do not have locale subtags" do
    let(:available) { %w{en es fr pt} }

    context "and the preferred language does not have a locale subtag" do
      context "and the preferred language matches an available language" do
        let(:preferred) { 'fr' }

        it "returns the matching available language" do
          expect(matcher.match(preferred)).to eq(preferred)
        end
      end

      context "and the preferred language does not match an available language" do
        let(:preferred) { 'zz' }

        it "returns nil" do
          expect(matcher.match(preferred)).to be_nil
        end
      end
    end

    context "and the preferred language has a locale subtag" do
      context "and the preferred language matches an available language" do
        let(:preferred) { 'pt-BR' }

        it "returns the matching available language" do
          expected = available.find { |a| preferred.start_with?(a) }
          expect(matcher.match(preferred)).to eq(expected)
        end
      end

      context "and the preferred language does not match an available language" do
        let(:preferred) { 'zz-BR' }

        it "returns nil" do
          expect(matcher.match(preferred)).to be_nil
        end
      end
    end
  end

  context "when the available languages have locale subtags" do
    let(:available) { %w{en-US es-ES fr-FR pt-BR} }

    context "and the preferred language does not have a locale subtag" do
      context "and the preferred language matches an available language" do
        let(:preferred) { 'fr' }

        it "returns the matching available language" do
          expected = available.find { |a| a.start_with?(preferred) }
          expect(matcher.match(preferred)).to eq(expected)
        end
      end

      context "and the preferred language does not match an available language" do
        let(:preferred) { 'zz' }

        it "returns nil" do
          expect(matcher.match(preferred)).to be_nil
        end
      end
    end

    context "and the preferred language has a locale subtag" do
      context "and the preferred language matches an available language" do
        let(:preferred) { 'pt-BR' }

        it "returns the matching available language" do
          expect(matcher.match(preferred)).to eq(preferred)
        end
      end

      context "and the preferred language does not match an available language" do
        let(:preferred) { 'zz-BR' }

        it "returns nil" do
          expect(matcher.match(preferred)).to be_nil
        end
      end
    end
  end

  context "when the multiple availale languages with the same language subtag" do
    let(:available) { %w{es-ES pt-PT pt-BR zh-TW zh-CN} }

    context "and the preferred language does not have a locale subtag" do
      context "and the preferred language matches an available language" do
        let(:preferred) { 'pt' }

        it "returns the first matching available language with that language subtag" do
          expected = available.find { |a| a.start_with?(preferred) }
          expect(matcher.match(preferred)).to eq(expected)
        end
      end
    end

    context "and the preferred language has a locale subtag" do
      context "and the preferred language matches one of the available languages with the same language subtag" do
        let(:preferred) { 'pt-PT' }

        it "returns the matching available language" do
          expect(matcher.match(preferred)).to eq(preferred)
        end
      end

      context "and the preferred language matches another of the available languages with the same language subtag" do
        let(:preferred) { 'pt-BR' }

        it "returns the matching available language" do
          expect(matcher.match(preferred)).to eq(preferred)
        end
      end

      context "and the preferred language matches an available language but differs on the subtag" do
        let(:preferred) { 'zh-HK' }

        it "returns the first matching available language with the same language subtag" do
          expected = available.find { |a| a.start_with?(preferred.split('-').first) }
          expect(matcher.match(preferred)).to eq(expected)
        end
      end
    end
  end
end
