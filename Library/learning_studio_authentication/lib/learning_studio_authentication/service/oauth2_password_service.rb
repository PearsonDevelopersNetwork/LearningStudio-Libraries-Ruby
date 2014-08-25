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

require "learning_studio_authentication/service/oauth2_service"

module LearningStudioAuthentication
  module Service
    # OAuth2 Password Service
    class OAuth2PasswordService < OAuth2Service
      GRANT_TYPE = "password".freeze
      REFRESH_GRANT_TYPE = "refresh_token".freeze

      # Generates an OAuth2 request object for password grant. This makes
      # an API call and generates a request object from the response.
      #
      # @param username [Sting], username for the request.
      # @param password [String], password for the request.
      # @return [LearningStudioAuthentication::Request::OAuth2Request] the request object.
      def generate_request(username, password)
        uname = CGI::escape("#{@configuration.client_string}\\#{username}")
        data = "grant_type=#{GRANT_TYPE}"
        data << "&client_id=#{CGI::escape(@configuration.application_id)}"
        data << "&username=#{uname}&"
        data << "password=#{CGI::escape(password)}"
        auth2_request(OAUTH_URL, data)
      end

      # Generates an OAuth2 request object for refresh token. This makes
      # an API call and generates a request object from the response.
      #
      # @param previous_request [LearningStudioAuthentication::Request::OAuth2Request] the request object which
      #   generated the access_token
      # @return [LearningStudioAuthentication::Request::OAuth2Request] the request object.
      def refresh_token_request(previous_request)
        data = "grant_type=#{REFRESH_GRANT_TYPE.encode('UTF-8')}"
        data << "&client_id=#{@configuration.application_id.encode('UTF-8')}"
        data << "&refresh_token=#{previous_request.refresh_token.encode('UTF-8')}"
        auth2_request(OAUTH_URL, data)
      end
    end
  end
end
