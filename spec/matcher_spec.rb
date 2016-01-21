require 'http_accept_language/matcher'

class DefaultMatcher; end
class FakeMatcher; end
class SecondMatcher; end

describe HttpAcceptLanguage::Matcher do
  let(:default_matcher) { double("default_matcher") }
  let(:fake_matcher) { double("fake_matcher") }
  let(:second_matcher) { double("second_matcher") }
  let(:available) { %w{en} }
  let(:preferred) { "en" }

  before do
    allow(HttpAcceptLanguage::Matcher).to receive(:default_matcher).and_return(DefaultMatcher)
    allow(DefaultMatcher).to receive(:new).with(an_instance_of(Array)).and_return(default_matcher)
    allow(FakeMatcher).to receive(:new).with(an_instance_of(Array)).and_return(fake_matcher)
    allow(SecondMatcher).to receive(:new).with(an_instance_of(Array)).and_return(second_matcher)
    allow(FakeMatcher).to receive(:matching_languages)
    allow(SecondMatcher).to receive(:matching_languages)
    HttpAcceptLanguage::Matcher.module_eval("@matchers = nil")
  end

  after do
    HttpAcceptLanguage::Matcher.module_eval("@matchers = nil")
  end

  context "when there are no matchers" do
    before do
      allow(HttpAcceptLanguage::Matcher).to receive(:get_included_matchers).and_return([])
    end

    it "uses the default matcher" do
      expected = 'zz'
      expect(default_matcher).to receive(:match).with(preferred).and_return(expected)
      expect(HttpAcceptLanguage::Matcher.match(available, preferred)).to eq(expected)
    end
  end

  context "when an included matcher exists for a language" do
    before do
      allow(HttpAcceptLanguage::Matcher).to receive(:get_included_matchers).and_return([FakeMatcher])
    end

    it "allows the included matcher to register for that language" do
      expect(FakeMatcher).to receive(:matching_languages).and_return(available)
      expect{HttpAcceptLanguage::Matcher.send(:register_included_matchers)}.not_to raise_error
    end

    it "uses the included matcher for matching that language" do
      expected = 'zz'
      expect(FakeMatcher).to receive(:matching_languages).and_return(available)
      expect(fake_matcher).to receive(:match).with(preferred).and_return(expected)
      expect(default_matcher).not_to receive(:match)
      expect(HttpAcceptLanguage::Matcher.match(available, preferred)).to eq(expected)
    end

    context "and a third-party matcher registers for the same language" do
      context "and replacement is allowed" do
        it "allows the third-party matcher to register for that language" do
          expect(FakeMatcher).to receive(:matching_languages).and_return(available)
          expect(SecondMatcher).to receive(:matching_languages).and_return(available)
          expect{HttpAcceptLanguage::Matcher.register(SecondMatcher, true)}.not_to raise_error
        end

        it "uses the third-party matcher for matching that language" do
          expected = 'zz'
          expect(FakeMatcher).to receive(:matching_languages).and_return(available)
          expect(SecondMatcher).to receive(:matching_languages).and_return(available)
          expect(second_matcher).to receive(:match).with(preferred).and_return(expected)
          expect(fake_matcher).not_to receive(:match)
          expect(default_matcher).not_to receive(:match)
          expect{HttpAcceptLanguage::Matcher.register(SecondMatcher, true)}.not_to raise_error
          expect(HttpAcceptLanguage::Matcher.match(available, preferred)).to eq(expected)
        end
      end

      context "and replacement is not allowed" do
        it "raises a RegistrationError" do
          expect(FakeMatcher).to receive(:matching_languages).and_return(available)
          expect(SecondMatcher).to receive(:matching_languages).and_return(available)
          expect{HttpAcceptLanguage::Matcher.register(SecondMatcher)}.to raise_error(HttpAcceptLanguage::Matcher::RegistrationError)
        end
      end
    end

    context "and the preferred language contains a region subtag" do
      let (:preferred) { 'en-US' }

      it "uses the matcher registered for the preferred language's language code" do
        expected = 'zz'
        expect(FakeMatcher).to receive(:matching_languages).and_return(available)
        expect(fake_matcher).to receive(:match).with(preferred).and_return(expected)
        expect(default_matcher).not_to receive(:match)
        expect(HttpAcceptLanguage::Matcher.match(available, preferred)).to eq(expected)
      end
    end

    context "and another included matcher exists for the same language" do
      before do
        allow(HttpAcceptLanguage::Matcher).to receive(:get_included_matchers).and_return([FakeMatcher, SecondMatcher])
      end

      it "raises a RegistrationError" do
        expect(FakeMatcher).to receive(:matching_languages).and_return(available)
        expect(SecondMatcher).to receive(:matching_languages).and_return(available)
        expect{HttpAcceptLanguage::Matcher.send(:register_included_matchers)}.to raise_error(HttpAcceptLanguage::Matcher::RegistrationError)
      end
    end
  end
end
