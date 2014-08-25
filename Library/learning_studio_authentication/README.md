# Learning Studio Authentication

This gem is a wrapper around Learningstudio OAuth libraries. It handles the following OAuth services.

1. OAuth 1 Signature Service
2. OAuth 2 Password Grant Service
3. OAuth 2 Assertion Grant Service

OAuth 2 Password Grant Service supports refresh token mechanism as well.

## Installation

### Dependencies

This gem is dependent on `libcryptopp` library. Install this library for your operating system before installing this gem.

See Gemfile.

### Installing the gem

#### Clone the source code

    cd /your/workspace/path
    git clone <git_url>

#### Install Gem

    cd /your/workspace/path/learning_studio_authentication
    rake install

### Documentation

Use YARD to generate the doc. To know how to install YARD, please visit https://github.com/lsegal/yard.

Once yard is installed, use the following command to generate documentaion for the gem.

    cd /your/workspace/path/learning_studio_authentication
    yard doc lib/**/*.rb


## Usage

### OAuth1 Signature Serive

```ruby
require 'learning_studio_authentication'
conf = LearningStudioAuthentication::Config::OAuthConfig.new({
    :application_id   => 'your_application_id',
    :application_name => 'your_application_name',
    :client_string    => 'your_client_string',
    :consumer_key     => 'consumer_key',
    :consumer_secret  =>  'consumer_secret'
})
service = LearningStudioAuthentication::Service::OAuth1SignatureService.new(conf)
request = service.generate_request(http_method, url, payload)
```

### OAuth2 Password Grant Service

```ruby
service = LearningStudioAuthentication::Service::OAuth2PasswordService.new(conf)
request = oauth_service.generate_request(username, password)
```

### OAuth2 Password Grant Service

```ruby
request = oauth_service.refresh_token_request(previous_request)
```

### OAuth2 Assertion Service

```ruby
service = LearningStudioAuthentication::Service::OAuth2AssertionService.new(conf)
request = service.generate_request(username)
```

## Running Tests

### Normal Run

This gem uses Minitest for tests. To run tests, run

    cd /your/workspace/path/learning_studio
    rake test

### With Coverage

To see the coverage report, run

    cd /your/workspace/path/learning_studio
    rake test

from your terminal.

## OAuth - Some Useful Links

###Links
1. [The OAuth 2.0 Authorization Framework RFC][1]
2. [Using OAuth 2.0 for Devices][2]
3. [OAuth 2 Simplified][3]
4. [Introducing OAuth 2.0][4]
5. [OAuth Bible (Only to understand, not a technical reference)][5]
6. [OAuth 1 RFC][8]

###Presentations
1. [Am OAuth 2.0 Demo][6]
2. [Understanding OAuth 2.0][7]


[1]: http://tools.ietf.org/html/rfc6749
[2]: https://developers.google.com/accounts/docs/OAuth2ForDevices
[3]: http://aaronparecki.com/articles/2012/07/29/1/oauth2-simplified
[4]: http://hueniverse.com/2010/05/introducing-oauth-2-0
[5]: http://oauthbible.com
[6]: https://github.com/Yasmine-Gaber/OAUTH2.0-Demo/blob/master/oauth2.0.ppt
[7]: http://www.slideshare.net/amitharsola/understanding-oauth-20
[8]: http://tools.ietf.org/html/rfc5849
