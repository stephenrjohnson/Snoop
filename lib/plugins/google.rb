require 'cinch'
require 'open-uri'
require "json"
require 'cgi'

class Google < CinchPlugin
  include Cinch::Plugin
  
  match /gmaps (.+)/,  method: :map
  match /google (.+)/, method: :web
  match /gvideo (.+)/, method: :video
  match /gimage (.+)/, method: :image
  set :help, "!google <query> - Search google for <query>\n!gmaps <query> - Produce google maps link\n!gvideo <query> - Search google video for <query>\n!gimage <query> - Search google images for <query>"

  def search(query,type)
    urlquery = CGI::escape(query)
    if type == "web"
      fullurl="http://www.google.com/search?q=#{urlquery}"
    elsif type == "video"
      fullurl="http://www.google.com/search?tbm=vid&q=#{urlquery}"
    elsif type == "images"
       fullurl="http://www.google.com/search?tbm=isch&q=#{urlquery}"
    elsif type == "map"
      return "http://map.google.com/maps?q=#{CGI.escape(query)}"
    end
      
    results = JSON.parse(open("http://ajax.googleapis.com/ajax/services/search/#{type}?v=1.0&q=#{urlquery}").read)
    firstresult = results["responseData"]['results'].first
    "Google #{type} Search Results for #{query}
    Title - #{CGI::unescapeHTML(firstresult['titleNoFormatting'])}
    Url - #{firstresult['url']}
    Full Search #{fullurl}"
  end

  def map(m, query)
     m.reply()
  end

  def video(m, query)
     m.reply(search(query,"video"))
  end

  def image(m, query)
     m.reply(search(query,"images"))
  end

  def web(m, query)
    m.reply(search(query,"web"))
  end
end