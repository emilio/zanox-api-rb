require File.join(File.dirname(__FILE__),"..","lib","zanox_api.rb")

client = Zanox::API::PublisherClient.new({ connect_id: 'XXX', secret_key: 'xxx' })

puts client.get_sales.inspect
