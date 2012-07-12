$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'http_accept_language'
require 'test/unit'

module ActionPack
  module VERSION
    MAJOR = 3
  end
end

module ActionDispatch
  class Request
  end
end

module ActionController
  class CgiRequest
  end
  class Request
  end
end

class MockedCgiRequest
  include HttpAcceptLanguage
  def env
    @env ||= {'HTTP_ACCEPT_LANGUAGE' => 'en-us,en-gb;q=0.8,en;q=0.6,es-419'}
  end
end

class HttpAcceptLanguageTest < Test::Unit::TestCase
  def test_should_return_empty_array
    request.env['HTTP_ACCEPT_LANGUAGE'] = nil
    assert_equal [], request.user_preferred_languages
  end

  def test_should_properly_split
    assert_equal %w{en-US es-419 en-GB en}, request.user_preferred_languages
  end

  def test_should_ignore_jambled_header
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'odkhjf89fioma098jq .,.,'
    assert_equal [], request.user_preferred_languages
  end

  def test_should_find_first_available_language
    assert_equal 'en-GB', request.preferred_language_from(%w{en en-GB})
  end

  def test_should_find_first_compatible_language
    assert_equal 'en-hk', request.compatible_language_from(%w{en-hk})
    assert_equal 'en', request.compatible_language_from(%w{en})
  end

  def test_should_find_first_compatible_from_user_preferred
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us,de-de'
    assert_equal 'en', request.compatible_language_from(%w{de en})
  end

  def test_should_accept_symbols_as_available_languages
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us'
    assert_equal :"en-HK", request.compatible_language_from([:"en-HK"])
  end

  def test_should_be_included_into_actionpack_v2
    silence_warnings do
      ActionPack::VERSION.const_set(:MAJOR, 2)
    end
    load "http_accept_language.rb"

    assert_include ActionController::Request.ancestors, HttpAcceptLanguage
    assert_include ActionController::CgiRequest.ancestors, HttpAcceptLanguage
  end

  def test_should_be_included_into_actionpack_v3
    silence_warnings do
      ActionPack::VERSION.const_set(:MAJOR, 3)
    end
    load "http_accept_language.rb"
    assert_include ActionDispatch::Request.ancestors, HttpAcceptLanguage
  end

  private

  def silence_warnings
    old_verbose, $VERBOSE = $VERBOSE, nil
    yield
  ensure
    $VERBOSE = old_verbose
  end

  def request
    @request ||= MockedCgiRequest.new
  end
end
