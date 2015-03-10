Gem::Specification.new do |s|
  s.name = 'dynarex-daily'
  s.version = '0.1.12'
  s.summary = 'dynarex-daily'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_runtime_dependency('dynarex', '~> 1.2', '>=1.2.90') 
  s.signing_key = '../privatekeys/dynarex-daily.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/dynarex-daily'
  s.required_ruby_version = '>= 2.1.2'
end
