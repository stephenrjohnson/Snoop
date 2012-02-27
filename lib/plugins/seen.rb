class Seen < CinchPlugin
  include Cinch::Plugin
  listen_to :channel,  method: :log
  match /seen (.+)/,  method: :search
  set :help, "!seen <nick> - Check when a nick was last seen"
  
  def initialize(*args)
    super
    @users = {}
  end

  def log(m)
    @users[m.user.nick] = "#{Time.now.asctime}] #{m.user} was seen in #{m.channel} saying #{m.message}"
  end 

  def search(m, nick)
    respond(m, message(m,nick))
  end

  def message(m, nick)
    if nick == @bot.nick
      message = "That's me!"
    elsif nick == m.user.nick
      message = "That's you!"
    elsif @users.key?(nick)
     message = @users[nick].to_s
    else
      message =  "I haven't seen #{nick}"
    end
    return message 
  end

  def respond (m, message)
     m.reply message
  end
end