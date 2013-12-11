#!/usr/bin/env ruby
require_relative '../lib/bot.rb'
require 'rubygems'
require 'optparse'
require 'bundler/setup'
require 'cinch'

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = 'Usage: snoop [options] ...'

  opts.separator ''
  opts.separator 'Configuration options:'

  opts.on( '-c', '--config-file FILE', 'The location of the config file.') { |config_file|
    options[:config_file] = config_file
  }

  opts.separator ""
  opts.separator "Options:"

  opts.on_tail('-h', '--help', 'Display help screen' ) do
    puts opts
    exit
  end
end

begin
  optparse.parse!
  Snoop::Bot.new(options)
rescue OptionParser::InvalidArgument, OptionParser::InvalidOption, OptionParser::MissingArgument
  puts $!.to_s
  puts optparse
  exit
end
