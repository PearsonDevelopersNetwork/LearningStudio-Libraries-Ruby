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

require "learning_studio_authentication/service/oauth1_signature_service"
require "learning_studio_authentication/service/oauth2_assertion_service"
require "learning_studio_authentication/service/oauth2_password_service"

module LearningStudioAuthentication
  module Service
    # Factory for building various OAuth services
    class OAuthServiceFactory
      attr_reader :configuration

      # Initializes an OAuth service factory object
      #
      # @param config  Configuration parameters shared between services
      def initialize(configuration)
        @configuration = configuration
      end

      # Builds the object for the specified classname.
      #
      # @param name [String] camelized class name
      # @return the object for the given class.
      def build(name)
        if !name.nil? && Service.const_defined?(name.to_sym)
          klass = Service.const_get(name.to_sym)
          klass.new(@configuration)
        else
          raise NotImplementedError, "#{name} is not implemented"
        end
      end
    end
  end
end
