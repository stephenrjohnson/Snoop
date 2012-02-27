require 'cinch'
require 'open-uri'
require 'nokogiri'

class UrbanDictionary < CinchPlugin
  include Cinch::Plugin

  match /urban (.*)/
  set :help, "!urban <query> - Lookup on urban dictionary may not be safe for work"
  def execute(m, query)
    m.reply search(query)
  end

  def search(query)
      url = URI.encode "http://www.urbandictionary.com/define.php?term=#{query}"
      "Urban Dictionary: #{Nokogiri.HTML(open url).at_css('.definition').text.strip}"
    rescue => e
      e.message
  end
end