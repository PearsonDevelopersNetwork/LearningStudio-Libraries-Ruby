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

# Represents an API response.
module LearningStudioCore
  # The response object returned by all Service objects
  class Response
    attr_reader :method, :url, :headers, :content_type, :is_binary, :status_message
    attr_writer :content
    attr_accessor :status_code

    def initialize(method, url, headers, content, content_type, is_binary, status_code, status_message)
      @method = method
      @url = url
	  @headers = headers
      @content = content
      @content_type = content_type
      @is_binary = is_binary
      @status_code = status_code
      @status_message = status_message
    end

    # Retuns content if content is not binary
    # @return [String] content
    def content
      @content unless @is_binary
    end

    def binary_content
      @content if @is_binary
    end


    # Indicates whether the content is binary. If so, it has been base64 encoded.
    #
    # @return [Boolean] indicator of binary content
    def binary_content?
      @is_binary
    end

    # Indicates whether the response is in an error state. Considers all 20x as
    #   a success.
    #
    # @return [Boolean] indicator of error
    def error?
      @status_code < 200 || @status_code >= 300
    end

    # String representation of the object
    #
    # @return [String] Stringified object.
    def to_s
      "Method: #{@method}, URL: #{@url}, Headers: #{@headers}, "\
	  "Code: #{@status_code}, Message: #{@status_message}, "\
	    "ContentType: #{@content_type}, Content: #{@content}"
        end
  end
end
