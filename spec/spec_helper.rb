require 'rubygems'
require 'bundler/setup'
require 'cinch'
require 'vcr'

require_relative '../lib/cinchplugin'
require_relative '../lib/settings'
Settings.path("./config/test.yml")
RSpec.configure do |config|
end

VCR.config do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
   c.stub_with :webmock # or :fakeweb
end


