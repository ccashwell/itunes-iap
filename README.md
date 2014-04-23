# ITunes IAP Receipt Analyzer & Validator

Validates iTunes In-App Purchase receipts with Apple and reports on status.

## Installation

Add this line to your application's Gemfile:

    gem 'itunes-iap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install itunes-iap

## Usage

    require 'itunes/iap'
    receipt = Itunes::IAP::Receipt.analyze(
      base64_receipt_data,
      shared_secret: shared_secret,
      sandbox: true
    )

### Attributes

- `:status` is the status code returned by Apple during validation
- `:response` is the raw response object from Apple
- `:original_transaction_id` is the original transaction ID, useful for validating uniqueness among users
- `:latest_transaction_id` is the most recent transaction ID
- `:product_id` is the product ID the purchase covers
- `:valid_until` is the expiration date of the purchase
- `:valid` is true only when Apple validated the provided receipt and the expiration date is in the future

## Contributing

1. Fork it ( http://github.com/litehouselabs/itunes-iap/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
