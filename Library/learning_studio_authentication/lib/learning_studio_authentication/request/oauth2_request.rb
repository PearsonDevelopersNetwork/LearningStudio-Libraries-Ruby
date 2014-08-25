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

require "learning_studio_authentication/request/oauth_request"

module LearningStudioAuthentication
  module Request
    # OAuth2 request
    class OAuth2Request < OAuthRequest
      attr_reader :access_token, :refresh_token,
        :expires_in_seconds, :creation_time, :expires_at

      def initialize(headers, access_token,
                     refresh_token, expires_in_seconds, creation_time)
        super(headers)
        @access_token = access_token
        @refresh_token = refresh_token
        @expires_in_seconds = expires_in_seconds
        @creation_time = creation_time
        if !expires_in_seconds.nil? && !creation_time.nil?
          @expires_at = creation_time + (expires_in_seconds * 1000)
        end
      end
    end
  end
end
