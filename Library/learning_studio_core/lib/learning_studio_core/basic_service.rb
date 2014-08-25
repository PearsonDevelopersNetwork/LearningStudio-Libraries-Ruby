#--
# LearningStudio RESTful API Libraries 
# These libraries make it easier to use the LearningStudio Course APIs.
# Full Documentation is provided with the library. 
#
# Need Help or Have Questions? 
# Please use the PDN Developer Community at https://community.pdn.pearson.com
#
# @category   LearningStudio Course APIs
# @author     Wes Williams <wes.williams@pearson.com>
# @author     Pearson Developer Services Team <apisupport@pearson.com>
# @copyright  2014 Pearson Education Inc.
# @license    http://www.apache.org/licenses/LICENSE-2.0  Apache 2.0
# @version    1.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#++

require 'uri'
require 'base64'
require 'logger'
require 'date'
require 'learning_studio_core/response'
require 'learning_studio_core/util'
require 'nokogiri'

module LearningStudioCore
  # A basic service exposing the core functionality of AbstractService without wrapping methods
  class BasicService
    class DataFormat
      JSON = "JSON".freeze
      XML = "XML".freeze
    end

    # Holds HTTP Status Code constatnts
    class HTTPStatusCode
      OK = 200.freeze
      CREATED = 201.freeze
      NO_CONTENT = 204.freeze
      BAD_REQUEST = 400.freeze
      FORBIDDEN = 403.freeze
      NOT_FOUND = 404.freeze
      INTERNAL_ERROR = 500.freeze
    end

    # Holds HTTP Method constants
    class HTTPMethods
      GET = "GET".freeze
      POST = "POST".freeze
      PUT = "PUT".freeze
      DELETE = "DELETE".freeze
    end

    # Hold different Authentication Service Identifiers for building service factory.
    class AuthMethod
      OAUTH1_SIGNATURE = "OAuth1SignatureService".freeze
      OAUTH2_ASSERTION = "OAuth2AssertionService".freeze
      OAUTH2_PASSWORD = "OAuth2PasswordService".freeze
    end

    HTTP_METHODS = [
      HTTPMethods::GET,
      HTTPMethods::POST,
      HTTPMethods::PUT,
      HTTPMethods::DELETE
    ].freeze

    API_DOMAIN = "https://api.learningstudio.com".freeze
    PATH_SYSTEMDATETIME = "/systemDateTime".freeze
    NO_CONTENT = "".freeze

    attr_accessor :data_format

    # Returns a new logger object
    def self.logger
      @logger ||= Logger.new('learning_studio.log')
    end

    # Returns a new logger object
    def logger
      self.class.logger
    end

	# Provides name of the service for identification purposes
	def self.service_identifier
	  return "LS-Library-Core-Ruby-V1"
	end
	
    # Returns a new instance of BasicService
    #
    # @param oauth_service_factory
    #   [LearningStudioCore::Service::OAuthServiceFactory]
    #     service provider for OAuth operations
    def initialize(oauth_service_factory)
      @oauth_service_factory = oauth_service_factory
      @data_format = DataFormat::JSON
      @auth_method = nil
      @username = nil
      @password = nil
      @current_oauth_request = nil
    end

    # Returns a new HTTPClinet connection object
    def connection
      @connectoin ||= HTTPClient.new
    end


    # Makes all future request use OAuth1 security
    def use_oauth1
      @auth_method = AuthMethod::OAUTH1_SIGNATURE
      @username = nil
      @password = nil
      @current_oauth_request = nil
    end

    # @overload use_oauth2(username)
    #   Makes all future request use OAuth2 assertion security
    #
    #   @param username [String] Username to be used for the service
    # @overload use_oauth2(username, password)
    #   Makes all future request use OAuth2 password security
    #
    #   @param username [String] Username to be used for the service
    #   @param password [String] Password to be used for the service
    def use_oauth2(username,  password = nil)
      if password.nil?
        @password = nil
        @auth_method = AuthMethod::OAUTH2_ASSERTION
      else
        @password = password
        @auth_method = AuthMethod::OAUTH2_PASSWORD
      end

      @username = username
      @current_oauth_request = nil
    end

    # Performs HTTP GET using the selected authentication method
    #
    # @param relative_url [String] The URL after .com (/me)
    # @param body [String] The body of the message
    # @param extra_headers [Hash] Extra headers to include in the request
    # @return Output in the preferred data format
    # @raise RuntimeError
    def get(relative_url, body = "", extra_headers = {})
      request(HTTPMethods::GET, relative_url, body, extra_headers)
    end

    # Performs HTTP POST using the selected authentication method
    #
    # @param relative_url [String] The URL after .com (/me)
    # @param body [String] The body of the message
    # @param extra_headers [Hash] Extra headers to include in the request
    # @return Output in the preferred data format
    # @raise RuntimeError
    def post(relative_url, body = "", extra_headers = {})
      request(HTTPMethods::POST, relative_url, body, extra_headers)
    end

    # Performs HTTP PUT using the selected authentication method
    #
    # @param relative_url [String] The URL after .com (/me)
    # @param body [String] The body of the message
    # @param extra_headers [Hash] Extra headers to include in the request
    # @return Output in the preferred data format
    # @raise RuntimeError
    def put(relative_url, body = "", extra_headers = {})
      request(HTTPMethods::PUT, relative_url, body, extra_headers)
    end

    # Performs HTTP DELETE using the selected authentication method
    #
    # @param relative_url [String] The URL after .com (/me)
    # @param body [String] The body of the message
    # @param extra_headers [Hash] Extra headers to include in the request
    # @return Output in the preferred data format
    # @raise RuntimeError
    def delete(relative_url, body = "", extra_headers = {})
      request(HTTPMethods::DELETE, relative_url, body, extra_headers)
    end

    # Performs HTTP operations using the selected authentication method
    #
    # @param method [String] The HTTP Method to user
    # @param relative_url [String] The URL after .com (/me)
    # @param body [String] The body of the message
    # @param extra_headers [Hash] Extra headers to include in the request
    # @return Output in the preferred data format
    # @raise RuntimeError
    def request(method, relative_url, body = "", extra_headers = {})
      if preferred_format == DataFormat::XML
        relative_url = append_extension(relative_url, ".xml")
      end

      full_url = API_DOMAIN + relative_url
      oauth_headers = get_oauth_headers(method, full_url, body)
      if oauth_headers.nil?
        raise RuntimeError, "Authentication method not selected. See use_auth# methods."
      end

      if !extra_headers.empty?
        if !(extra_headers.keys & oauth_headers.keys).empty?
          raise RuntimeError, 'Extra headers can not include OAuth headers.'
        else
          oauth_headers = oauth_headers.merge(extra_headers)
        end
      end

      logger.debug("REQUEST - Method: #{method} URL: #{full_url} Body: #{body} Headers: #{oauth_headers.inspect}")

      response = nil
      headers = Marshal.load(Marshal.dump(oauth_headers))
	  headers['User-Agent'] = self.class.service_identifier
      if ['POST', 'PUT'].include?(method) && body.length > 0
        byte_array = body.encode('utf-8')
        headers['Content-Type'] = 'application/json'
        headers['Content-Length'] = byte_array.length
        response = connection.request(method, full_url, nil, byte_array, headers)
      else
        response = connection.request(method, full_url, nil, nil, headers)
      end
      content = response.body
      content_type = response.headers['Content-Type']
	  if !content_type.nil?
	    is_binary = !content_type.include?('text') && !content_type.include?('xml') && !content_type.include?('json')
        content = Base64.decode64(content) if is_binary
	  end
	  
      Response.new(method, full_url, headers, content,
                         content_type, is_binary,
                         response.status, response.reason)
    end

    # Performs time lookup with /systemDateTime using OAuth1 or OAuth2
    #
    # @return Response object with details of status and content
    def system_datetime
      request(HTTPMethods::GET, PATH_SYSTEMDATETIME)
    end

    alias_method :preferred_format, :data_format
    alias_method :preferred_format=, :data_format


    # Performs time lookup with /systemDateTime using OAuth1 or OAuth2
    #
    # @return  The milliseconds since the unix epoch
    def system_datetime_millis
      response = self.system_datetime()
      if response.error?
        raise IOError, "Time lookup failed:  #{response.status_code} - #{response.status_message}."
      end
      content = response.content
      time_value = nil
      if @data_format == DataFormat::XML
        time_value = parse_xml_tag(content, ['systemDateTime', 'value'])
      else
        json_data = JSON.parse(content)
        time_value = json_data['systemDateTime']['value']
      end

      datetime_to_millis(time_value)
    end

    # Release all handles to objects that may prevent garbage collection
    def destroy!
      @oauth_service_factory = nil
      @data_format = nil
      @auth_method = nil
      @username = nil
      @password = nil
      @current_oauth_request = nil
    end

    private
    def append_extension(url, extension)
      uri = URI.parse(url)
      # Append extension only if doesn't already exist.
      unless uri.path.end_with?(extension)
        uri.path += extension
      end
      uri.to_s
    end

    def get_oauth_headers(method, url, body)
      service = @oauth_service_factory.build(@auth_method)
      headers = nil
      if @auth_method == AuthMethod::OAUTH1_SIGNATURE
        request = service.generate_request(method, url, body)
        headers = request.headers
      else
        if !@current_oauth_request.nil?
          if LearningStudioCore::Util.current_time_millis >= @current_oauth_request.expires_at
            logger.debug "Previous OAuth2 headers have expired"
            if @auth_method == AuthMethod::OAUTH2_PASSWORD
              logger.debug "Refreshing oauth2 token."
              current_request = @current_oauth_request
              begin
                logger.debug("Refreshing oauth2 token")
                @current_oauth_request = service.refresh_token_request(current_request)
              rescue Exceptoin => e
                logger.debug("Failed to refresh oauth2 token", e.to_s)
              end
            else
              @current_oauth_request = nil
            end
          end
        end
        if @current_oauth_request.nil?
          logger.debug("Generating new OAuth2 headers.")
          if @auth_method == AuthMethod::OAUTH2_PASSWORD
            @current_oauth_request = service.generate_request(@username, @password)
          elsif @auth_method == AuthMethod::OAUTH2_ASSERTION
            @current_oauth_request = service.generate_request(@username)
          else
            raise NotImplementedError, "Auth method #{@auth_method.to_s} is not implemented."
          end
        end
      end
      headers = @current_oauth_request.headers unless @current_oauth_request.nil?
      #Return a deep copy object to prevent mutation.
      Marshal.load(Marshal.dump(headers))
    end

    def datetime_to_millis(time_value)
      # FIXME: Do we really need utc conversion??
      DateTime.parse(time_value).to_time.utc.to_f * 1000
    end

    def parse_xml_tag(xml, tags)
      Nokogiri::XML(xml).xpath(tags.join("/")).text
    end
  end
end
