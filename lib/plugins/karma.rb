require 'cinch'

class Karma < CinchPlugin
  include Cinch::Plugin
  match /(\w*)[+]{2}/, method: :increment, use_prefix: false
  match /(\w*)[-]{2}/, method: :decrement, use_prefix: false
  match /karma[ ]?(\w*)?/, method: :show_scores
  set :help, "<username>++ or <username>-- or karma <username> or karma"

  def initialize(*args)
    super
    @scores_file = "/tmp/karma.json"
    if File.exist? @scores_file
      File.open(@scores_file, "r") do |f|
        @users = JSON.parse(f.read)
        @users.default = 0
      end
    else
      @users = Hash.new(0)
    end
  end

  def increment(m, nick)
    if nick == @bot.nick
      m.reply "Increasing my karma would result in overflow."
    elsif nick == m.user.nick
      m.reply "Just keep patting yourself on the back there, sport."
    elsif nick != ""
      update_user(nick) { |nick| @users[nick] += 1 }
      show_scores(m, nick)
    end
  end

  def decrement(m, nick)
    if nick == @bot.nick
      m.reply "I wouldn't do that if I were you..."
    elsif nick == m.user.nick
      m.reply "There are special rooms on this network for self-flagellation."
    elsif nick != ""
      update_user(nick) { |nick| @users[nick] -= 1 }
      show_scores(m, nick)
    end
  end

  def show_scores(m, nick)
     if nick != ""
       m.reply "#{ nick } has #{ @users[nick] } awesome points."
     else
      sorted_users = @users.sort_by { |k, v| v }
      top_scores   = sorted_users.take(5)
      top_scores.each { |nick, score| m.reply "#{ nick } has #{ @users[nick] } awesome points." }
     end
  end

  def update_user(nick)
    yield(nick)
    save
  end

  def save
    File.open(@scores_file, "w") do |f|
      f.write(@users.to_json)
    end
  end
end
