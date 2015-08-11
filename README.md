# Zanox API Client
This gem wraps a [savon](http://www.savonrb.com/) client to provide easy access to the Zanox API.

# Installation
```
$ gem install zanox_api
```

Or, in your `Gemfile`:

```
gem 'zanox_api', '~> 0.1.0'
```

## Example Usage
```ruby
require 'zanox_api'

# There are multiple clients available, one for each service Zanox provides:
#  - PublisherClient
#  - DataClient
#  - ConnectClient
client = Zanox::API::PublisherClient.new(connect_id: 'XXX', secret_key: 'xxx')

puts client.get_sales.inspect

# Parameters are passed to the soap message
puts client.get_sale(id: "xx").inspect
```
