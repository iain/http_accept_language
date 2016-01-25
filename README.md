# HttpAcceptLanguage [![Build Status](https://travis-ci.org/iain/http_accept_language.svg?branch=master)](https://travis-ci.org/iain/http_accept_language)

A gem which helps you detect the user's preferred language, as sent by the "Accept-Language" HTTP header.

This gem contains a number of algorithms to select an available language matching the user's preferred language.

The default algorithm is based on [RFC 2616](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html), with one exception:
when a user requests "en-US" and "en" is an available language, "en" is deemed compatible with "en-US".
The RFC specifies that the requested language must either exactly match the available language or must exactly match a prefix of the available language. This means that when the user requests "en" and "en-US" is available, "en-US" would be compatible, but not the other way around. This is usually not what you're looking for.

The Chinese-language algorithm uses the conversions described in [RFC 5646](https://tools.ietf.org/html/rfc5646), and is based on work done by [Wikimedia](https://phabricator.wikimedia.org/T91151), [Mozilla](https://github.com/mozilla/persona/issues/3044), et al. to determine the appropriate Chinese fallback order for various combinations of language, script, and region subtags. The process of matching the user's preferred language to an available language when the user's preferred language is a variant of Chinese is as follows:
First, try to exactly match an available language (e.g. "zh-TW" or "zh-Hans"). If no exact match is found, determine the script code (explicit or implied) of the user's preferred language. If the user's preferred language contains a region code, try to match an available language with the same script and region codes as the preferred language. If no match is found or if the user's preferred language does not contain a region code, try to match an available language with the same script code as the preferred language and which includes the "default" (primary / most common) region code for that script ("CN" for "Hans", "TW" for "Hant"). If a language with the "default" region code for that script code is not available, finally try to match any available language using that script code.
Extended language subtags are partially supported. The "zh" primary language subtag without an extended language subtag is considered to be equivalent to the combination "zh-cmn", as is the improper case where the extended language subtag "cmn" alone is provided without a primary language subtag. These cases require the further presence of either a script or a region subtag (or both) in order to correctly identify a fallback language if no exact match is found, because the "cmn" language code has no implied script code, and thus could be presented in either the "Hans" and "Hant" scripts, and selecting the wrong script could have undesirable consequences from a cultural standpoint. The combination "zh-yue" is also considered equivalent with the improper case where the extended language subtag "yue" alone is provided without a primary language subtag. In these cases, if neither a script nor a region subtag is present and no exact match is found, an exception to the previously-described policy is made and falling back to a language using the "Hant" script code is permitted. Other extended language subtags within the Chinese language family are not currently supported.

Since version 2.0, this gem is Rack middleware.

## Example

The `http_accept_language` method is available in any controller:

```ruby
class SomeController < ApplicationController
  def some_action
    http_accept_language.user_preferred_languages # => %w(nl-NL nl-BE nl en-US en)
    available = %w(en en-US nl-BE)
    http_accept_language.preferred_language_from(available) # => 'nl-BE'

    http_accept_language.user_preferred_languages # => %w(en-GB)
    available = %w(en-US)
    http_accept_language.compatible_language_from(available) # => 'en-US'

    http_accept_language.user_preferred_languages # => %w(nl-NL nl-BE nl en-US en)
    available = %w(en nl de) # This could be from I18n.available_locales
    http_accept_language.preferred_language_from(available) # => 'nl'
  end
end
```

You can easily set the locale used for i18n in a before-filter:

```ruby
class SomeController < ApplicationController
  before_filter :set_locale

  private
    def set_locale
      I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
    end
end
```

If you want to enable this behavior by default in your controllers, you can just include the provided concern:

```ruby
class ApplicationController < ActionController::Base
  include HttpAcceptLanguage::AutoLocale

#...
end
```

Then set available locales in `config/application.rb`:

```ruby
config.i18n.available_locales = %w(en nl de fr)
```

To use the middleware in any Rack application, simply add the middleware:

``` ruby
require 'http_accept_language'
use HttpAcceptLanguage::Middleware
run YourAwesomeApp
```

Then you can access it from `env`:

``` ruby
class YourAwesomeApp

  def initialize(app)
    @app = app
  end

  def call(env)
    available = %w(en en-US nl-BE)
    language = env.http_accept_language.preferred_language_from(available)

    [200, {}, ["Oh, you speak #{language}!"]]
  end

end
```

## Available methods

* **user_preferred_languages**:
  Returns a sorted array based on user preference in HTTP_ACCEPT_LANGUAGE, sanitized and all.
* **preferred_language_from(languages)**:
  Finds the locale specifically requested by the browser
* **compatible_language_from(languages)**:
  Returns the first of the user_preferred_languages that is compatible with the available locales.
  Ignores region.
* **sanitize_available_locales(languages)**:
  Returns a supplied list of available locals without any extra application info
  that may be attached to the locale for storage in the application.
* **language_region_compatible_from(languages)**:
  Returns the first of the user preferred languages that is
  also found in available languages.  Finds best fit by matching on
  primary language first and secondarily on region.  If no matching region is
  found, return the first language in the group matching that primary language.

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
