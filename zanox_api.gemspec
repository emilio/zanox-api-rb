# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'zanox_api'
  s.version = '0.2.0'
  s.summary = 'Zanox API client'
  s.authors = ['Emilio Cobos Álvarez']
  s.date = '2015-08-11'
  s.description = 'Simple client for zanox SOAP API'
  s.email = 'emiliocobos@usal.es'
  s.files = ['lib/zanox_api.rb']
  s.homepage = 'https://github.com/ecoal95/zanox-api-rb'
  s.license = 'MIT'
  s.add_runtime_dependency 'savon', '~>2.0'
end

