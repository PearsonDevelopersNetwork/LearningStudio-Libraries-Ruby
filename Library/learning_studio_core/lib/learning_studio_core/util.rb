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

require 'learning_studio_authentication/ruby_cryptopp'
require 'learning_studio_authentication/request/oauth2_request'
require 'json'
require 'httpclient'

module LearningStudioCore
  class Util
    # Generates OAuth1 signature using CMAC.
    #
    # @param keydata [Sting], the key for encryption
    # @param msg [String], message to be encrypted
    # @param b64 [Boolean], set to true if the return value needs to be Base64
    #   encoded
    # @return [String] the encrypted message
    def self.gen_authcode(keydata, msg, b64 = true)
      result = LearningStudioAuthentication::AuthUtil.gen_authcode(keydata, msg, b64 ?  1 : 0)
      result.gsub("\n", "")
    end

    # Current time in milliseconds
    #
    # @return [Fixnum] current time in milliseconds
    def self.current_time_millis
      (Time.new.to_f * 1000).round
    end
  end
end
