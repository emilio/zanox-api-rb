# Zanox API Client [![Build Status](https://travis-ci.org/ecoal95/zanox-api-rb.svg?branch=master)](https://travis-ci.org/ecoal95/zanox-api-rb)
This gem wraps a [savon](http://www.savonrb.com/) client to provide easy access to the Zanox API.

# Installation
```
$ gem install zanox_api
```

Or, in your `Gemfile`:

```
gem 'zanox_api', '~> 0.2.0'
```

## Example Usage
```ruby
require 'zanox_api'

# There are multiple clients available, one for each service Zanox provides:
#  - PublisherClient
#  - DataClient
#  - ConnectClient
client = Zanox::API::PublisherClient.new(connect_id: 'XXX', secret_key: 'xxx')

# To use methods which require authentication you must use the "authenticated_" prefix
puts client.authenticated_get_sales(date: Date.today).inspect

# You can use just the method name for methods which doesn't require it
puts client.search_programs.inspect

# Parameters are passed to the soap message
puts client.authenticated_get_sale(id: "xx").inspect
```
