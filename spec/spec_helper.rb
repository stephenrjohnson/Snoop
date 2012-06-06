require 'rubygems'
require 'bundler/setup'
require 'cinch'
require 'vcr'

require_relative '../lib/cinchplugin'
require_relative '../lib/settings'
Settings.path("./config/test.yml")
RSpec.configure do |config|
end

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock # or :fakeweb
end


