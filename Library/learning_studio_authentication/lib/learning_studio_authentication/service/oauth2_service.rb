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

require "cgi"
require "uri"
require "base64"
require "learning_studio_authentication/config"
require "learning_studio_authentication/request"
require "learning_studio_authentication/util"

module LearningStudioAuthentication
  module Service
    # Base class for OAuth2 services
    class OAuth2Service
      OAUTH_API_DOMAIN = 'https://api.learningstudio.com'.freeze
      OAUTH_URL = OAUTH_API_DOMAIN + '/token'.freeze

      protected
      # Initializes a new  OAuth1SignatureService object
      # @param configuration [LearningStudioAuthentication::Config::OAuthConfig]
      #   configuration parameter object.
      def initialize(configuration)
        @configuration = configuration
      end

      def generate_request
        raise NotImplementedError, "Subclass needs to implement this method"
      end

      # @return - an HTTP connection object.
      def connection
        @connection ||= HTTPClient.new
      end

      # Creates an OAuth2 request.
      #
      # @param url [String] HTTP url
      # @param data [String] HTTP payload.
      # @return [LearningStudioAuthentication] object which encapsulates response.
      def auth2_request(url, data)
        byte_array = data.encode('UTF-8')
        headers = {
          'Content-Type' => 'application/x-www-form-urlencoded',
		  'User-Agent' => 'LS-Library-OAuth-Ruby-V1',
        }
        response = connection.post(url, byte_array, headers)
        json_response = JSON.parse(response.body)
        json_to_oauth2request(json_response)
      end

      private
      def json_to_oauth2request(json_data)
        access_token = json_data['access_token']

        if access_token.nil? || access_token == ""
          raise IOError, "Missing access token."
        end

        creation_time = Util::current_time_millis
        auth_str = "Access_Token access_token=#{access_token}"
        headers = { "X-Authorization" => auth_str.encode('utf-8') }
        Request::OAuth2Request.new(headers, access_token,
                                          json_data['refresh_token'],
                                          json_data.key?('expires_in') ? json_data['expires_in'] : 0,
                                          creation_time)
      end
    end
  end
end
