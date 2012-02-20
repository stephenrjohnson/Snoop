require 'cinch'
require 'cgi'

class GoogleMaps < CinchPlugin
  include Cinch::Plugin
  plugin "map"
  help "!map <query> - Search google maps for <query>"

  match /map (.+)/

  def search(query)
    "http://map.google.com/maps?q=#{CGI.escape(query)}"
  end

  def execute(m, query)
    m.reply(search(query))
  end
end