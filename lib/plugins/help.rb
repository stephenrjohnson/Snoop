class Help < CinchPlugin
  include Cinch::Plugin
  set :help, "!help <name> - Get information about a command (or all commands with no name)"

  match /help$/, method: :without_name

  def without_name(m)
    @bot.plugins.each do |plugin|
      help_message = plugin.class.help
      if help_message
        name = plugin.class.plugin_name
        m.reply "#{help_message}"
      end
    end
  end
end
