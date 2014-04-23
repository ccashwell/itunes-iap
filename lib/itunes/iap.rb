require 'json'
require 'net/https'
require 'ostruct'
require 'uri'

require 'itunes/iap/version'

module Itunes
  module IAP
    class Receipt
      PRODUCTION_VALIDATION_URL = 'https://buy.itunes.apple.com/verifyReceipt'
      SANDBOX_VALIDATION_URL    = 'https://sandbox.itunes.apple.com/verifyReceipt'

      attr_reader :verified_receipt

      class << self
        def analyze base64_receipt, options = {}
          receipt = new(base64_receipt, options)
          out = Hash.new.tap do |r|
            r[:status] = receipt.verified_receipt['status']
            r[:response] = receipt.verified_receipt
            if r[:status] == 0
              newest_transaction = receipt.verified_receipt['latest_receipt_info'].last
              r[:original_transaction_id] = newest_transaction['original_transaction_id']
              r[:latest_transaction_id] = newest_transaction['transaction_id']
              r[:product_id] = newest_transaction['product_id']
              r[:valid_until] = Time.at(
                receipt
                  .verified_receipt['latest_receipt_info']
                  .last['expires_date_ms']
                  .to_i / 1000
              )
              r[:valid] = Time.now < r[:valid_until]
            else
              r[:valid] = false
            end
          end

          out
        end
      end

      def initialize base64_receipt, options = {}
        @base64_receipt = base64_receipt
        @options = options
        @verified_receipt = update_receipt
      end

      private

      def update_receipt
        request_parameters = Hash.new.tap do |params|
          params['receipt-data'] = @base64_receipt
          params['password'] = @options[:shared_secret] if @options[:shared_secret]
        end

        validation_uri = URI(validation_url)
        adapter = Net::HTTP.new(validation_uri.host, validation_uri.port)
        adapter.use_ssl = true
        adapter.verify_mode = OpenSSL::SSL::VERIFY_PEER

        request = Net::HTTP::Post.new(validation_uri.request_uri)
        request['Accept'] = "application/json"
        request['Content-Type'] = "application/json"
        request.body = request_parameters.to_json

        response = adapter.request(request)

        json = JSON.parse(response.body)
      end

      def validation_url
        if @options[:validation_url]
          @options[:validation_url]
        elsif @options[:sandbox]
          SANDBOX_VALIDATION_URL
        else
          PRODUCTION_VALIDATION_URL
        end
      end
    end

  end
end
