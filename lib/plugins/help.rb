class Help < CinchPlugin
  include Cinch::Plugin

  plugin "help"
  help "!help <name> - Get information about a command (or all commands with no name)"

  match /h(?:elp)?$/, method: :listall

  def listall(m)
    @bot.plugins.each do |plugin|
      help_message = plugin.class.instance_variable_get(:@__cinch_help_message)
      if help_message
        name = plugin.class.instance_variable_get(:@__cinch_name)
        m.reply "#{help_message}"
      end
    end
  end
end
