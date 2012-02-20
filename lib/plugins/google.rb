require 'cinch'
require 'open-uri'
require "json"
require 'cgi'

class Google < CinchPlugin
  include Cinch::Plugin
  plugin "google"
  help "!google <query> - Search google for <query>"

  match /google (.+)/

  def search(query)
    urlquery = CGI::escape(query)
    results = JSON.parse(open("http://ajax.googleapis.com/ajax/services/search/web?v=1.0&q=#{urlquery}").read)
    firstresult = results["responseData"]['results'].first
    "Google Results for #{query}
    Title - #{CGI::unescapeHTML(firstresult['titleNoFormatting'])}
    Url - #{firstresult['url']}
    Full Search http://www.google.com/search?q=#{urlquery}"
  end

  def execute(m, query)
    m.reply(search(query))
  end
end