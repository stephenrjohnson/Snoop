require 'cinch'
require 'open-uri'
require 'nokogiri'

class FWeather < CinchPlugin
  include Cinch::Plugin

  match /fweather (.*)/
  set :help, "!fweather <query> - Lookup the f*cking weather, not safe for work"
  def execute(m, query)
    m.reply search(query)
  end

  def search(query)
      url = URI.encode "http://thefuckingweather.com/?where=#{query}"
      response = Nokogiri.HTML(open url).at_css('.remark')
      detail = Nokogiri.HTML(open url).at_css('.large.specialCondition')
      flavor = Nokogiri.HTML(open url).at_css('.flavor')
      if response
        "The F*cking Weather: #{response.text.strip} #{detail ? detail.text.strip : ""} #{flavor ? ", "+flavor.text.strip : ""}"
      else
        "The F*cking Weather: Not Found Beatch"
      end
    rescue => e
      e.message
  end
end
