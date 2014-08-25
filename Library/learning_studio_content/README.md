# Learning Studio Content

Ruby wrapper around Pearson's Learning Studio Content - REST APIs.

## Dependencies
Please see Gemfile.

Please make sure to change the path in Gemfile for the Authentication library before you install Core library.

## Installing the gem

### Clone the source code

    cd /your/workspace/path
    git clone <git_url>

### Install Gem

    cd /your/workspace/path/learning_studio_content
    rake install

## Documentation (Generate Yard Documentaion)

Use YARD to generate the doc. To know how to install YARD, please visit https://github.com/lsegal/yard.

Once yard is installed, use the following command to generate documentaion for the gem.

    cd /your/workspace/path/learning_studio_content
    yard doc lib/**/*.rb

## Usage
### Requires
```ruby
require 'learning_studio_authentication'
require 'learning_studio_content'
```

### Setup

```ruby
conf = LearningStudioAuthentication::Config::OAuthConfig.new({
    :application_id   => 'your_application_id',
    :application_name => 'your_application_name',
    :client_string    => 'your_client_string',
    :consumer_key     => 'consumer_key',
    :consumer_secret  =>  'consumer_secret'
})

oauth_factory = LearningStudioAuthentication::Service::OAuthServiceFactory.new(conf)
service = LearningStudioContent::Service.new(oauth_factory)
```

### Choose Auth for subsequent request

```ruby
service.use_oauth1
```
OR

```ruby
service.use_oauth2
```

### Choose a content type
```ruby
service.data_format = LearningStudioCore::BasicService::DataFormat::JSON
```

### Make a request

```ruby
response = service.get_items(course_id)
```

### Destroy service when finished to release resources

```ruby
service.destroy!
```

