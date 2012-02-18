require 'open-uri'
require 'simple-rss'

class Redmine < CinchPlugin
  include Cinch::Plugin
  plugin "redmine"
  listen_to :channel
  match /watch (.+)/,  method: :add
  match /unwatch (.+)/,  method: :remove
  help "!watch [name] - Watch a redmine project \n!unwatch [name] - unwatch a redmine project"

  timer 120, method: :fetchupdates

  def initialize(*args)
    super
    @watched = {}
    @times = {}
    @redmineurl = "#{$config['redmine']['server']}/projects/"
    @rsskey = "/activity.atom?key=#{$config['redmine']['apikey']}&"
    @option = "show_changesets=1&show_documents=1&show_files=1&show_hudson=1&show_messages=1&show_news=1&show_time_entries=1&show_wiki_edits=1"
  end


  def fetchupdates
    @bot.debug "featching updates #{@watched}"
    @watched.each   do |key, value|
      begin
        feed = fetchfeed(key)
        if timeisnew?(key, feed.first[:updated])
          Channel(@watched[key][:channel]).send "#{feed.first[:title]} #{feed.first[:updated]}"
        end
      rescue OpenURI::HTTPError
        Channel(@watched[key][:channel]).send "Remove #{key} as url no longer valid"
        @watched.delete(key)
      end
    end
  end

  def fetchfeed(site)
    rss = SimpleRSS.parse(open(@redmineurl+site+@rsskey+@option))
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
      @bot.debug  "Watching #{@watched[watch]}"
      
    else
      begin
        fetchfeed(watch)
        @watched[watch] = {user: m.user.nick, channel: m.channel}
        m.reply "Watching #{watch}"
        @bot.debug  "Watching #{@watched[watch]}"
        fetchupdates
      rescue OpenURI::HTTPError
        m.reply "Cant get redmine site for #{watch}"
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

end
