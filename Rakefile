require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('myshows', '0.2.0') do |p|
  p.summary        = "MyShows API"
  p.description    = "Object-oriented wrapper over API of http://myshows.ru"
  p.url            = "http://github.com/cypok/myshows"
  p.author         = "Vladimir Parfinenko"
  p.email          = "vladimir.parfinenko@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.runtime_dependencies = ["httparty", "crack", "memoize"]
  p.development_dependencies = ["rspec"]
end

