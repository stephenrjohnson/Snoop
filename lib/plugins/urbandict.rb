require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'cgi'

class UrbanDictionary < CinchPlugin
  include Cinch::Plugin

  match /urban (.*)/
  set :help, "!urban <query> - Lookup on urban dictionary may not be safe for work"
  def execute(m, query)
    m.reply search(query)
  end

  def search(query)
      url = URI.encode "http://www.urbandictionary.com/define.php?term=#{CGI::escape(query)}"
      response = Nokogiri.HTML(open url).at_css('.meaning')
      if response
        "Urban Dictionary: #{response.text.strip}"
      else
        "Urban Dictionary: Not Found Beatch"
      end
    rescue => e
      e.message
  end
end
