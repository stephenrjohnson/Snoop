require 'rack'
require 'cgi'

class WebInterfaceThread < CinchThread
  def initialize(bot)
    @bot = bot
  end

  def start
    @bot.debug "webserver starting"
    Rack::Handler::WEBrick.run(self, {:Port => Settings.webinterface.port, :Host => Settings.webinterface.bindaddress})
  end

  def call(env)
    request = Rack::Request.new(env)
    params =  request.GET()
    if params['key'] == nil
      [500, {"Content-Type" => "text/json"},["Please provide key"]]
    elsif params['key'] == nil || params['message'] == nil || params['message'] == nil
      [500, {"Content-Type" => "text/json"},["Please provide get params key,message,channel",params.inspect]]
    elsif params['key'] == Settings.webinterface.key.to_s

      if params['colour'] != nil
        if params['colour'] == 'blue' then colour = :blue end
        if params['colour'] == 'red' then colour = :red end
        if params['colour'] == 'green' then colour = :green end
        if params['colour'] == 'black' then colour = :black end
        if params['colour'] == 'yellow' then colour = :yellow end
        if params['colour'] == 'orange' then colour = :orange end
      else
        colour = ''
      end
      message=CGI.unescape(params['message'])
      tchannel=CGI.unescape(params['channel'])

      @bot.channels.each{ | channel |
        if channel.name == tchannel
          channel.send(Cinch::Formatting.format(colour,message))
        end
      }

      [200, {"Content-Type" => "text/json"},[params.inspect]]
    else
      [500, {"Content-Type" => "text/json"},["Error"]]
    end
  end

end

