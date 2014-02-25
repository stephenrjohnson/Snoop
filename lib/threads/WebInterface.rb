require 'rack'
class WebInterfaceThread < CinchThread
  def initialize(bot)
    @bot = bot
  end

  def start
    @bot.debug "webserver starting"
    Rack::Handler::WEBrick.run self, :Port => Settings.webinterface.port
  end

  def call(env)
    request = Rack::Request.new(env)
    params =  request.GET()
    if params['key'] == nil
      [500, {"Content-Type" => "text/json"},["Please provide key"]]
    elsif params['key'] == nil || params['message'] == nil || params['message'] == nil 
      [500, {"Content-Type" => "text/json"},["Please provide get params key,message,channel",params.inspect]]
    elsif params['key'] == Settings.webinterface.key.to_s 
      message=Rack::Utils.unescape(params['message']).to_s
      tchannel=Rack::Utils.unescape(params['channel']).to_s
       
      @bot.channels.each{ | channel |
        if channel.name == tchannel
          channel.send(message)
	end
      }

      [200, {"Content-Type" => "text/json"},[params.inspect]]
    else
      [500, {"Content-Type" => "text/json"},["Error"]]
    end
  end

end

