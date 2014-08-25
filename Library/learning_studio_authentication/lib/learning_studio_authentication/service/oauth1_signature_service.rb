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
    # OAuth1 Signature Service
    #
    class OAuth1SignatureService
      SIGNATURE_METHOD = "CMAC-AES".freeze

      # Initializes a new  OAuth1SignatureService object
      # @param configuration [LearningStudioAuthentication::Config::OAuthConfig]
      #   configuration parameter object.
      def initialize(configuration)
        @configuration = configuration
      end

      # Generates an OAuth1 request object
      #
      # @param http_method [Sting] the HTTP method, `'GET'`,
      #   `'PUT'`, `'POST'`, `'DELETE'`, etc.
      # @param url [String] HTTP URL.
      # @param body [String] Payload string
      # @return [LearningStudioAuthentication::Request::OAuth1Request] the request object.
      def generate_request(http_method, url, body)
        http_method = http_method.upcase
        uri = URI.parse(url)
        oauth_params = {
          'oauth_consumer_key' => @configuration.consumer_key,
          'application_id' => @configuration.application_id,
          'oauth_signature_method' => SIGNATURE_METHOD,
          'oauth_timestamp' => timestamp(),
          'oauth_nonce' => nonce()
        }

        body = ['POST', 'PUT'].include?(http_method) && body.is_a?(String) ? body.encode('UTF-8') : nil
        oauth_params['oauth_signature'] = generate_signature(http_method, uri,
                                                             oauth_params, body,
                                                             @configuration.consumer_secret)
        sign = make_signature(oauth_params)
        headers = make_headers(uri, sign)
        oauth_request = Request::OAuth1Request.new(sign)
        oauth_request.headers = headers
		oauth_request.signature = oauth_params['oauth_signature']
        oauth_request
      end

      private

      def generate_signature(http_method, uri, oauth_params, body, secret)
        encoded_params = normalize_params(http_method, uri, oauth_params, body)
        encoded_uri = CGI.escape(uri.path)
        message = "#{http_method}&#{encoded_uri}&#{encoded_params}"
        generate_cmac(secret, message)
      end

      def normalize_params(http_method, uri, oauth_params, body_bytes)
        oauth_params = Marshal.load(Marshal.dump(oauth_params))
        query_hash = {}
        query_string = uri.query
        query_hash = CGI.parse(query_string) unless query_string.nil?
        qdict = Hash[query_hash.map { |k, v| [k, v[0].to_s] unless v[0].nil? }]
        oauth_params = oauth_params.merge(qdict)
        unless body_bytes.nil?
          data = Base64.encode64(body_bytes).gsub("\r", "").gsub("\n", "")
          # NOTE: URL encode 2 times before combining with other params
          oauth_params['body'] = CGI.escape(CGI.escape(data))
        end

        oauth_params = oauth_params.sort_by { |k, v| k.downcase }
        combined_params = oauth_params.inject('') { |cp, param| cp << "#{param[0]}=#{param[1]}&" }
        ret = CGI.escape(combined_params[0...-1])
      end

      def make_signature(oauth_params)
        oauth_params.sort_by{|key, val| key.downcase }.map{ |a| "#{a[0]}=#{CGI.escape(a[1])}" }.join(",")
      end

      def make_headers(uri, sign)
        { "X-Authorization" => "OAuth realm=#{uri.to_s.partition('?').first},#{sign}" }
      end

      def nonce
        length = 32
        rand(36**length).to_s(36)
      end

      def timestamp
        Time.now.to_i.to_s
      end

      def generate_cmac(key, msg)
        LearningStudioAuthentication::Util.gen_authcode(key, msg)
      end
    end
  end
end
