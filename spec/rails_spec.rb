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
    stub_const("ActionPack::VERSION::MAJOR", 2)
    load "http_accept_language/rails.rb"

    ActionController::Request.ancestors.should include HttpAcceptLanguage::Rails
    ActionController::CgiRequest.ancestors.should include HttpAcceptLanguage::Rails
  end

  it "should be included into actionpack v3" do
    stub_const("ActionPack::VERSION::MAJOR", 3)
    load "http_accept_language/rails.rb"
    ActionDispatch::Request.ancestors.should include HttpAcceptLanguage::Rails
  end

end
