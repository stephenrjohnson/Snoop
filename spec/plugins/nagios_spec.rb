require "spec_helper"
require "plugins/nagios"

describe Nagios do
    describe "Nagios plugin" do

    before(:all) do 
      VCR.configure do |c|
        c.filter_sensitive_data("<NAGIOS_USERNAME>") {"NAGIOS_USERNAME"}
        c.filter_sensitive_data("<NAGIOS_PASSWORD>") {"NAGIOS_PASSWORD"}
        c.filter_sensitive_data("<NAGIOSURL>") {"NAGIOSURL"}
      end
    end


    before(:each) do 
        @m = mock.as_null_object
        @nagiosplugin = Nagios.new(@m)
    end

    it "I should be able to get all the results from nagios" do
        VCR.use_cassette('nagios_test') do
          @nagiosplugin.alerts.include?("HTTP CRITICAL")
        end 
    end

  end
end



