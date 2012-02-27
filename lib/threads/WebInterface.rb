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
  		[200, {"Content-Type" => "text/html"},["Please provide get params key,message,channel"]]
  	elsif params['key'] == nil || params['message'] == nil || params['message'] == nil 
  		[500, {"Content-Type" => "text/html"},["Please provide get params key,message,channel",params.inspect]]
  	elsif params['key'] == $config['webinterface']['key'].to_s 
  		@bot.dispatch(:webmessage, nil , params['message'].to_s, params['channel'].to_s)
   	 	[200, {"Content-Type" => "text/html"},[params.inspect]]
   	else
   	 	[500, {"Content-Type" => "text/html"},["Error"]]
   	end
  end

end

