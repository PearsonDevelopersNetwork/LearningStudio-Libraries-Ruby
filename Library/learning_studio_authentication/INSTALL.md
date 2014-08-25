# Installation
This document contains instructions for installing the Ruby library `learning_studio_authentication` for both development and production environments.

Before we dig further into the installation process, let's see what the pre-requisites are.

-  **Ruby 1.9.3p547** (This library has been developed and tested on this Ruby versions. It should work with 1.9.x and 2.0.x versions of Ruby, but for now, using Ruby 1.9.3p547 is highly recommended.)
- **Crypto++, v5.2.0** Using a native installation for your OS is highly recommended even though it can be installed from the source as well.
    1. **Installing from Source on any platform**
        Download Source from here: http://sourceforge.net/projects/cryptopp/files/cryptopp/5.2.1/cryptopp521.zip/download?use_mirror=kaz and install it.

    2. **Installation on Mac OS X (10.9.2) using Homebrew**
    If you have Homebrew installed, you can install Cypto++ by running the following command:
    ```sh
    brew install cryptopp
    ```
    3. **Installation on Ubuntu 13.04 using apt-get**
    Run the following command from your terminal:
    ```sh
    sudo apt-get install libcrypto++ libcrypto++-dev
    ```
- **RVM** (For dev environments)
To get instructions on how to install RVM and more details, please see https://rvm.io

## Installation on Dev Environments
If you want to play around with the source code for debugging purpose, follow the steps below.

- Get the latest source code and cd into `/your/path/learning_studio_authentication`
- Using RVM, create a new gemset for the project using
```sh
rvm 1.9.3p547@your_gemset_name --create --ruby-version
```
- Install all the dependencies using `bundler`.
```sh
bundle install
```
- Build the native extensions for Crypto++ using the following commands
```sh
cd ext/learning_studio_authentication
bundle exec ruby extconfig.rb
```
- This will create a `Makefile`. Then run the following command to generate the shared object for crtyptopp module which can be loaded using Ruby.
```sh
make
```

**NOTE**: Any project which requires this library needs to have the dependency specified in the Gemfile for development environments. Find the Gemfile of the project that you're working on and update the path to the Authentication Library.

For example, the Gemfile of the Core library should have

```ruby
gem 'learning_studio_authentication', :path=>'/your/path/learning_studio_authentication'
```

After this process, you should be able to require the gem into any Ruby script

```ruby
require 'learning_studio_authentication'

puts LearningStudioAuthentication.version
```

## Installation on Production Environments
For production environments we have to package the library as a `gem` so that anyone can install it. Run the following commands to build the gem and install the library using it.

```sh
cd /your/path/learning_studio_authentication
bundle install
gem build learning_studio_authentication.gemspec
```

This should generate a new file named `learning_studio_authentication-0.0.1.gem`. You can install the gem using the following command (You can copy the gem).
```sh
gem install learning_studio_authentication-0.0.1.gem
```

After this process, you should be able to require the gem into any Ruby script

```ruby
require 'learning_studio_authentication'

puts LearningStudioAuthentication.version
```

To know more in detail about how to use the gem, see README and yard documentation for the project.
