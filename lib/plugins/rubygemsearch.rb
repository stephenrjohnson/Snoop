require 'cinch'
require 'open-uri'
require "json"
require 'cgi'

class Rubygemsearch < CinchPlugin
  include Cinch::Plugin
  match /gems (.+)/,  method: :search
  match /gem (.+)/,  method: :gem
  set :help, "!gems <query> - Search rubygems for <query>\n!gem <query> - Info about gem"

  def search(m, query)
    urlquery = CGI::escape(query)
    results = JSON.parse(open("https://rubygems.org/api/v1/search.json?query=#{urlquery}").read)
    m.reply("RubyGem results
      Name: #{results.first['name']} Downloads: #{results.first['downloads']}  
      Version: #{results.first['version']} Url: #{results.first['project_uri']}
      Full search: https://rubygems.org/search?query=#{urlquery}")
  end

  def gem(m, query)
     urlquery = CGI::escape(query)
     result = JSON.parse(open("http://rubygems.org/api/v1/gems/#{query}.json").read)
     m.reply("The #{result['name']} gem claims #{result['info']} and is authored by #{result['authors']}")
  end
end