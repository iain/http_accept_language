Feature: Rails Integration

  To use http_accept_language inside a Rails application, just add it to your
  Gemfile and run `bundle install`.

  It is automatically added to your middleware.

  Scenario: Installing
    When I generate a new Rails app
    And I add http_accept_language to my Gemfile
    And I run `bundle exec rake middleware`
    Then the output should contain "use HttpAcceptLanguage::Middleware"
