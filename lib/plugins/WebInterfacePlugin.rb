class WebInterfacePlugin < CinchPlugin
  include Cinch::Plugin

  listen_to :webmessage
  def listen(m, message, channel)
    Channel(channel).send "Webmessage: #{message}"
  end
end