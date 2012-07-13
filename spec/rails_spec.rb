require 'http_accept_language'

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

describe "Rails integration" do

  it "should be included into actionpack v2" do
    silence_warnings do
      ActionPack::VERSION.const_set(:MAJOR, 2)
    end
    load "http_accept_language/rails.rb"

    ActionController::Request.ancestors.should include HttpAcceptLanguage
    ActionController::CgiRequest.ancestors.should include HttpAcceptLanguage
  end

  it "should be included into actionpack v3" do
    silence_warnings do
      ActionPack::VERSION.const_set(:MAJOR, 3)
    end
    load "http_accept_language/rails.rb"
    ActionDispatch::Request.ancestors.should include HttpAcceptLanguage
  end

  def silence_warnings
    old_verbose, $VERBOSE = $VERBOSE, nil
    yield
  ensure
    $VERBOSE = old_verbose
  end

end
