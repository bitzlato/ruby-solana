# Solana

Ruby library for solana blockchain. It support generation and storing keys, generating and signing transactions. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'solana'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install solana

## Usage
  ## Keys

    secret_key = [44, 98, 215, 237, 34, 123, 89, 247, 206, 196, 165, 5, 232, 42, 79, 158, 27, 20, 165, 137, 124, 155, 216, 126, 167, 178, 46, 57, 164, 181, 156, 43].pack('C*')
    from_key =  Solana::Key.new(secret_key)
    to_pubkey = '3wh7S43AJW5FyYnJUFbhn7hBvSSfuQbPozmf1xMohWiX'

    tx = Solana::Tx.new
    instruction = Solana::Program::System.transfer_instruction(from_pubkey: from_key.address, to_pubkey: to_pubkey, lamports: 3000)
    tx.add(instruction)
    tx.recent_blockhash = client.get_recent_blockhash
    tx.fee_payer = from_key.address
    tx.sign([from_key])
    client.send_transaction(tx.to_base64)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bitzlato/ruby-solana.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
