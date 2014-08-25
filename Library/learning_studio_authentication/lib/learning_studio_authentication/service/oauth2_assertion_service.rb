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
    # OAuth2 Assertion Service
    #
    class OAuth2AssertionService < OAuth2Service
      GRANT_TYPE = "assertion".freeze
      ASSERTION_TYPE = 'urn:ecollege:names:moauth:1.0:assertion'.freeze

      # Generates an OAuth2 request object after completing an OAuth2 request
      # with grant `assertion` as the grant_type.
      #
      # @param username [Sting] the username for the request
      # @return [LearningStudioAuthentication::Request::OAuth2Request] the request object.
      def generate_request(username = nil)
        assertion = build_assertion(username)
        data = "grant_type=#{GRANT_TYPE}&assertion_type=#{ASSERTION_TYPE}&assertion=#{assertion}"
        auth2_request(OAUTH_URL, data)
      end

      private
      def build_assertion(username)
        timestamp = Time.new.strftime('%Y-%m-%dT%H:%M:%SZ')
        assertion = "#{@configuration.application_name}|"
        assertion << "#{@configuration.consumer_key}|"
        assertion << "#{@configuration.application_id}|"
        assertion << "#{@configuration.client_string}|"
        assertion << "#{username}|"
        assertion << "#{timestamp}"
        cmac = LearningStudioAuthentication::Util.gen_authcode(@configuration.consumer_secret, assertion, false)
        "#{assertion}|#{cmac}"
      end
    end
  end
end
