require 'cinch'
require 'nagiosharder'

class Nagios < CinchPlugin
  include Cinch::Plugin
  match /nagios$/i,  method: :list
  match /nagios (.+)/,  method: :alerts
  set :help, "!nagios - List servers\n!nagios <server> - List problems on that instances"
  

  def list(m)
    m.reply("Nagios instances")
    $config['nagios']['servers'].each do |key, instance|
      m.reply("    Server #{key} : #{instance['description']}")
    end
  end

  def alerts(m, query)
    if $config['nagios']['servers'].key?(query)
      begin
         problems(query).each do |problem|
          m.reply("#{problem['host']}: #{problem['duration']} #{problem['service']} #{problem['status']} \n url #{problem['service_extinfo_url']}")
         end
      rescue
      end
    else
     m.reply("Invalid server #{query}")
   end
  end

  def problems(site)
    url = $config['nagios']['servers']["#{site}"]['url']
    username = $config['nagios']['servers']["#{site}"]['username']
    password = $config['nagios']['servers']["#{site}"]['password']
    timeformat = $config['nagios']['servers']["#{site}"]['timeformat']
    site = NagiosHarder::Site.new(url,username,password)
    site.nagios_time_format = timeformat
    return site.service_status(:all_problems)
  end
end
