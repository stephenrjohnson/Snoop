require 'settingslogic'
class Settings < Settingslogic
  def self.path(path)
    @@config_file = path || File.expand_path("./config/config.yml")
    if !File.exist?(@@config_file)
      puts "There's no configuration file at #{config_file}!"
      exit!
    else
     source @@config_file
    end
  end
end