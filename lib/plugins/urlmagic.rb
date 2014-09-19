require 'cinch'
require 'mechanize'
require 'bitly'

class Urlmagic < CinchPlugin
include Cinch::Plugin
  match /(https?:\/\/[^\s]+)/, use_prefix: false
    def execute(m, url)
      puts "calling shortner"
      if url.match(/open\.spotify/)
        return
      end

      agent = Mechanize.new
      page = agent.get(url)
      begin
        title = page.title.gsub(/[\r\n\t]/, '')
      rescue
        title nil
	debug "could not get title"
      end
      
      shortURL = ""
      if url.length > 80
        Bitly.use_api_version_3
	bitly = Bitly.new('o_7ao1emfe9u', 'R_b29e38be56eb1f04b9d8d491a4f5b344')
	shortURL = bitly.shorten(url).short_url
      end
      unless title.nil?
        m.reply "\"#{title}\""
        m.reply "#{shortURL}"
      else
        m.reply "#{shortURL}"
      end
   end
end
