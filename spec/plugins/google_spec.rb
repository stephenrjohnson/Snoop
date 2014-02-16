require "spec_helper"
require "plugins/google"

describe Google do
    describe "Goolge plugin" do

    before(:each) do 
        @m = double.as_null_object
        @googleplugin = Google.new(@m)
    end

    it "When i search for a place on google maps it should return an url" do
        @googleplugin.search("SW1A 2AA","map").should =~ /^.*http:\/\/map.google.com\/maps\?q=SW1A\+2AA$/
    end

    it "When i search for cinch ruby it should be the top result" do
        VCR.use_cassette('google_web_cinch') do
           @googleplugin.search("cinch ruby","web") =~ /Cinch: A Ruby IRC Bot Building Framework/
        end
    end

    it "When i do a video search for cinch ruby it should be the top result" do
        VCR.use_cassette('google_video_cinch') do
           @googleplugin.search("Gary Bernhardt javascript wat","video") =~ /Shaky cam footage of PhRUG watching WAT/
        end
    end

    it "When i do a image search for wat it should be the top result" do
        VCR.use_cassette('google_images_cinch') do
           @googleplugin.search("darth wat","images") =~ /WAT\? A Funny Look at Ruby and JavaScript Oddities/
        end
    end
  end
end
