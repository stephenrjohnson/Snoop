require 'cinch'
require 'escape'
require 'tzinfo'

class Ping < CinchPlugin
  include Cinch::Plugin
  match /time (.+)/,  method: :tz
  set :help, "!time <tz> - Get time in <query>"

  def tz(m, query)
    users = Settings.time
    begin
      if users.has_key?(query)
        tz = TZInfo::Timezone.get(users[query])
        m.reply("Its #{tz.now.strftime('%A %H:%M:%S')} for #{query}")
      else
        tz = TZInfo::Timezone.get(query)
        m.reply("Its #{tz.now.strftime('%A %H:%M:%S')} in #{tz}")
      end
    rescue
      m.reply("Invalid timezone #{query}")
    end
  end
end
