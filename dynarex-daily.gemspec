Gem::Specification.new do |s|
  s.name = 'dynarex-daily'
  s.version = '0.1.4'
  s.summary = 'dynarex-daily'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('dynarex') 
  s.signing_key = '../privatekeys/dynarex-daily.pem'
  s.cert_chain  = ['gem-public_cert.pem']
end
