require "spec_helper"
require "plugins/seen"

describe Seen do
	describe "Seen plugin" do

	before(:each) do 
		args = mock.as_null_object
		@mockmessage =  mock "Cinch::Message"
		@mockmessage.stub(:user).and_return(mock("Cinch::Nick", :nick => "testuser"))
		@mockmessage.stub(:channel).and_return("#testchannel")
		@mockmessage.stub(:message).and_return("test message")
		@seenplugin = Seen.new(args)
		@seenplugin.log(@mockmessage)
	end

    it "Should respond thats you if your asking about yourself" do
		@seenplugin.message(@mockmessage,"testuser").should === "That's you!"
    end

    it "Should respond havn't seen if you are talking about no one" do
		@seenplugin.message(@mockmessage,"testuser1").should === "I haven't seen testuser1" 
    end

    it "Should give a valid output if you asking about someone it has seen" do
		mockmessage =  mock "Cinch::Message"
		mockmessage.stub(:user).and_return(mock("Cinch::Nick", :nick => "testuser1"))
		mockmessage.stub(:channel).and_return("#testchannel")
		mockmessage.stub(:message).and_return("test message")
		@seenplugin.message(mockmessage,"testuser").should include("was seen in")
    end

  end
end
