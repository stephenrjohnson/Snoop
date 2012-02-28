require 'cinch'
require 'nagiosharder'

class Nagios < CinchPlugin
  include Cinch::Plugin
  match /nagios$/,  method: :list
  set :help, "!nagios - List problems on all instances"
  
  def list (m)
    alerts.each do |item|
      m.reply(item)
    end
  end

  def alerts
    items = Array.new
    if Settings.nagios.servers
      begin
        Settings.nagios.servers.each do |site, server|
          items << "Server : #{site} \n"
          query(site,:all_problems).each do |problem|
          items << "#{problem['host']}: #{problem['duration']}  
                    #{problem['service']} #{problem['status']} 
                    url #{problem['service_extinfo_url']}"
          end
        end
        return items
      rescue => e
        puts e
        return false
      end
    end
  end

  def query(site, query)
    url = 
    Settings.nagios.servers.send(site).url
    username = Settings.nagios.servers.send(site).username
    password = Settings.nagios.servers.send(site).password
    timeformat = Settings.nagios.servers.send(site).timeformat
    site = NagiosHarder::Site.new(url,username,password)
    site.nagios_time_format = timeformat
    return site.service_status(query)
  end
end
