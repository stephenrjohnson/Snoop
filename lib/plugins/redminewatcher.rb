require 'open-uri'
require 'simple-rss'
require 'date'
require 'time-ago-in-words'

class RedmineWatcher < CinchPlugin
  include Cinch::Plugin
  match /watch (.+)/,  method: :add
  match /unwatch (.+)/,  method: :remove
  match /watching/, method: :watching

  set :help, "!watch <name> - Watch a redmine project \n!unwatch [name] - unwatch a redmine project\n!watching list all watched redmine project"
  timer Settings.redminewatcher.fetchint, method: :fetchupdates

  def initialize(*args)
    super
    @watched = {}
    @times = {}
    @redmineurl = "#{Settings.redminewatcher.server}/projects/"
    @questtring = "/activity.atom?key=#{Settings.redminewatcher.apikey}&#{Settings.redminewatcher.options}"
  end

  def fetchupdates
    @watched.each   do |key, value|
      begin
        feed = fetchfeed(key)
        if feed.first[:updated] != @times[key]
          feed.first(5).each do |item|
            if item[:updated] != @times[key]
              author = item[:author].split("\n")
              friendlydate = item[:updated].time_ago_in_words
              Channel(@watched[key][:channel]).send "#{key} #{string_truncate(item[:title])} #{friendlydate} #{author[0].strip}<#{author[1] ? author[1].strip : "" }>"
            end
          end
           @times[key] = feed.first[:updated]
        end
      rescue OpenURI::HTTPError
        Channel(@watched[key][:channel]).send "Remove #{key} as url no longer valid"
        @watched.delete(key)
      end
    end
  end

  def fetchfeed(site)
    rss = SimpleRSS.parse(open("#{@redmineurl}#{site}#{@questtring}"))
    return rss.items
  end

  def timeisnew?(time, site)
    if @times[site] == time
      return false
    else
      @times[site] = time
      return true
    end
  end

  def add(m, watch)
    if @watched.key?(watch)
      m.reply "Already watching #{watch} #{@watched[watch][:user]} told me to, annoucing in #{@watched[watch][:channel]}"
    else
      begin
        fetchfeed(watch)
        @watched[watch] = {user: m.user.nick, channel: m.channel}
        m.reply "Watching #{watch}"
        fetchupdates
      rescue OpenURI::HTTPError
        m.reply "Cant get redmine site for #{watch}"
        @bot.debug  "Error Waatching #{watch}"
      end
    end
  end

  def remove(m, watch)
    if @watched.key?(watch)
      @bot.debug  "Unwatching #{@watched[watch]}"
      @watched.delete(watch)
      m.reply "Not watching #{watch} anymore"
    else
      m.reply "Not watching #{watch}"
      @bot.debug  "Not watching #{watch}"
    end
  end
  
  def watching(m)
    m.reply "Watching ..."
    @watched.each do |key, item|
      m.reply "#{key} in #{item[:channel]} by request of  #{item[:user]}"
    end
  end
end
