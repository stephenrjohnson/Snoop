require 'cinch'
require 'open-uri'
require 'cgi'

class IsUp < CinchPlugin
  include Cinch::Plugin
  set :help, "!is <site> up|down - Check with www.isup.me"

  match /is (.*?) (up|down)(\?)?/, method: :runcheck

  def check(domain)
    url = "http://www.isup.me/#{CGI::escape(domain)}"
    responce = open(url).read
    if responce.match("It's just you.")
      return "Its up and working must be just you"
    elsif responce.match("It's not just you!")
      return "Its not up"
    else
      return "Check yourself i dont know"
    end
  end

  def runcheck(m, domain)
    m.reply(check(domain))
  end
end
