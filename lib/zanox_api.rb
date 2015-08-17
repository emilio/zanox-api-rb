require 'securerandom'
require 'savon'

module Zanox
  module API
    # Returns the signature for the Zanox auth
    def self.signature(service_name, method_name, timestamp, nonce, secret_key)
      string_to_sign = service_name + method_name + timestamp + nonce
      digest = OpenSSL::Digest.new('sha1')

      Base64.encode64(OpenSSL::HMAC.digest(digest, secret_key, string_to_sign))[0..-2]
    end

    # Build the adecuate soap parameters for a method, signing the request
    # following Zanox spec
    def self.params_for_method(service_name, method_name, secret_key = nil)
      if secret_key
        timestamp = Time.new.gmtime.strftime("%Y-%m-%dT%H:%M:%S.000Z")
        nonce = SecureRandom.uuid
        {
          timestamp: timestamp,
          nonce: nonce,
          signature: signature(service_name, method_name, timestamp, nonce, secret_key),
        }
      else
        {}
      end
    end

    def self.normalize_response(response)
      # Convert items to array
      if response.has_key?(:items)
        items = response[:items].to_i
        if items == 0
          response = []
        else
          items_key = response.keys.select { |k| k.to_s.end_with?('_items') }.first
          response = response[items_key]

          # converts xxx_items to xxx_item
          item_key = items_key.to_s[0..-2].to_sym

          response = response[item_key]

          if items == 1
            response = [response]
          end
        end
      end

      response
    end

    class Client
      # Service name is one of 'publisherservice', 'dataservice' or 'connectservice'
      # Valid options are:
      #  * connect_id
      #  * secret_key
      #  * api_url (optional, defaults to the current API url: http://api.zanox.com/wsdl/2011-03-01')
      #  * normalize_responses: Get the responses normalized.
      #                         This means that if the response is an array it will return just the array itself, for example
      #  * log, log_level, logger, pretty_print_xml: This options are passed directly to `Savon.client`
      def initialize(service_name, options = {})
        @service_name = service_name
        @connect_id = options[:connect_id]
        @secret_key = options[:secret_key]
        @base_api_url = options[:api_url] || 'https://api.zanox.com/wsdl/2011-03-01'
        @normalize_responses = options[:normalize_responses]

        @savon_client = Savon.client({
                                       wsdl: @base_api_url,
                                       log: options[:log],
                                       log_level: options[:log_level],
                                       logger: options[:logger],
                                       pretty_print_xml: options[:pretty_print_xml],
                                     })
      end

      def method_missing(name, *args, &block)
        name = name.to_s
        params = if name.start_with?('authenticated_')
          name = name.gsub(/^authenticated_/, '')
          Zanox::API.params_for_method(@service_name, name.gsub('_', '').downcase, @secret_key)
        else
          {}
        end

        params.merge!(connect_id: @connect_id)
        params.merge!(args[0] || {})
        response = @savon_client.call(name.to_sym, message: params)
        contents = response.body[(name + '_response').to_sym]
        if @normalize_responses
          Zanox::API.normalize_response(contents)
        else
          contents
        end
      end
    end

    class PublisherClient < Client
      def initialize(options = {})
        super('publisherservice', options)
      end
    end

    class DataClient < Client
      def initialize(options = {})
        options[:api_url] ||= 'https://data.zanox.com/wsdl/2011-05-01'
        super('dataservice', options)
      end
    end

    class ConnectClient < Client
      def initialize(options = {})
        super('connectservice', options)
      end
    end
  end
end
