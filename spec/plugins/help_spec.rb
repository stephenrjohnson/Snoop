require "spec_helper"
require "plugins/help"

describe Help do
  describe "listall" do
    it "should return a youtube result" do
		m = mock.as_null_object
		Help.listall(m).should =~ /^.* : http:\/\/www.youtube.com\/.*$/
    end
  end
end
