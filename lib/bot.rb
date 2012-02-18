require_relative 'cinchplugin.rb'
require_relative 'cinchthread.rb'
require 'yaml'

module Snoop
  class Bot
    ##load the plugins
      def initialize(options)
        config(options)
        threads
        run
      end

      def config(options)
        config_file = options[:config_file] || File.expand_path("./config/config.yml")
        if !File.exist?(config_file)
          puts "There's no configuration file at #{config_file}!"
          exit!
        else
          $config = YAML.load_file(config_file)
        end
        plugins = getallplugins
        puts plugins.inspect
        @bot = Cinch::Bot.new do
          configure do |c|
            c.server   = $config['bot']['server']
            c.port     = $config['bot']['port']
            c.nick     = $config['bot']['nick']
            c.channels = $config['bot']['channels']
            c.verbose  = $config['bot']['verbose']
            c.plugins.plugins  = plugins
          end
        end
      end

      def getallplugins
        Dir.glob(File.expand_path(".")+'/lib/plugins/*.rb') do |item|
          require item
        end

        plugins = Array.new()
        Object.constants().map do |const|
          begin
            klass = eval("#{const}")
            if klass.superclass.to_s == "CinchPlugin"
             plugins << klass
            end
          rescue
          end
        end
        return plugins
      end

      def run
        @bot.start
      end

      def threads
        Dir.glob(File.expand_path(".")+'/lib/threads/*.rb') do |item|
          require item
        end
        Object.constants().map do |const|
          begin
            klass = eval("#{const}")
            if klass.superclass.to_s == "CinchThread"
             Thread.new{ klass.new(@bot).start }
            end
          rescue
          end
        end
      end
  end
end