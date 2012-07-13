# HttpAcceptLanguage

A small effort in making a plugin which helps you detect the users preferred language, as sent by the HTTP header.

Since version 2.0, this gem is Rack middleware.

## Features

* Splits the http-header into languages specified by the user
* Returns empty array if header is illformed.
* Corrects case to xx-XX
* Sorted by priority given, as much as possible.
* Gives you the most important language
* Gives compatible languages

See also: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html

## Example

When using in Rails:

``` ruby
class SomeController < ApplicationController

  def some_action

    http_accept_language.user_preferred_languages # => [ 'nl-NL', 'nl-BE', 'nl', 'en-US', 'en' ]
    available = %w{en en-US nl-BE}
    http_accept_language.preferred_language_from(available) # => 'nl-BE'

    http_accept_language.user_preferred_languages # => [ 'en-GB']
    available = %w{en-US}
    http_accept_language.compatible_language_from(available) # => 'en-US'

  end

end
```

Older versions of Rails (pre 3.0) might need to include the middleware manually.

Usage in any Rack application, simple add the middleware:

``` ruby
require 'http_accept_language'
use HttpAcceptLanguage::Middleware
run YourAwesomeApp
```

Then you can access it:

``` ruby
class YourAwesomeApp

  def self.call(env)
    available = %w(en en-US nl-BE)
    language = env.http_accept_language.preferred_language_from(available)
    [ 200, {}, ["Oh, you speak #{language}!"]]
  end

end
```

## Installation


### Without Bundler

Install the gem `http_accept_language`

### With Bundler

Add the gem to your Gemfile:

``` ruby
gem 'http_accept_language'
```

Run `bundle install` to install it.

---

Released under the MIT license
