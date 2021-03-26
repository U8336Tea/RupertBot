#!/usr/bin/ruby

require 'discordrb'
require 'yaml'

require_relative 'responder'
require_relative 'rule'
require_relative 'dm'

config_file = File.open ARGV[0]
$config = YAML.safe_load config_file.read
$target_rules = load_rules $config['target_rules']
$blacklist = load_rules $config['blacklist']

$client = Discordrb::Bot.new(token: $config['token'], type: :user)
$client.run(background: true)

$server = $client.servers[$config['server']]
$channel = $server.text_channels.filter do |chan|
    chan.id == $config['channel']
end[0]

Thread.new do
    sleep_string = $config['sleep_time']
    next unless sleep_string

    hour, minute = sleep_string.split(':')
    hour = hour.to_i
    minute = minute.to_i

    now = Time.now
    sleep_hours = hour - now.hour
    sleep_minutes = (sleep_hours * 60) + (minute - now.min)
    sleep_seconds = sleep_minutes * 60
    if sleep_seconds < 0
        puts "Stopping at #{Time.now}"
        exit 0
    end
    
    sleep sleep_seconds
    puts "Stopping at #{Time.now}"
    exit 0
end

$client.dm do |event|
    handle_dm event
end

loop do
    begin
        responder = Responder.new($client, $config['timeout'])
        responder.listen $channel
    ensure
        responder.destruct
    end
end
