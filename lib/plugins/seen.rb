class Seen < CinchPlugin
  include Cinch::Plugin
  listen_to :channel
  plugin "seen"
  match /seen (.+)/
  help "!seen <nick> - Check when a nick was last seen"
  
  def initialize(*args)
    super
    @users = {}
  end

  def listen(m)
    @users[m.user.nick] = "#{Time.now.asctime}] #{m.user} was seen in #{m.channel} saying #{m.message}"
  end

  def execute(m, nick)
    if nick == @bot.nick
      m.reply "That's me!"
    elsif nick == m.user.nick
      m.reply "That's you!"
    elsif @users.key?(nick)
      m.reply @users[nick].to_s
    else
      m.reply "I haven't seen #{nick}"
      @bot.debug @users
    end
  end
end