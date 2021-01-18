require_relative 'rule'

def handle_dm(event)
    message = event.content.downcase
    handle_shutdown event if message.include? 'shutdown'
    handle_blacklist event if message.include? 'blacklist'
    handle_target event if message.include? 'target'
end

private
def parse_dm(type, event)
    message = event.content
    author = event.author
    command = message.split
    puts
    puts "Received #{type} message from #{author.username}##{author.discriminator}: #{message}"
    return message, author, command
end

def handle_shutdown(event)
    message, author, command = parse_dm(:shutdown, event)
    
    if command.length > 1 then
        arg = command[1]
        exit 1 if $channel == arg || $channel.name.downcase == arg.downcase
        exit 1 if $server == arg || $server.name.downcase == arg.downcase
    else
        exit 1
    end
end

def handle_blacklist(event)
    message, author, command = parse_dm(:blacklist, event)

    return unless command.length == 3
    $blacklist.append Rule.new(type: command[1], id: command[2])
end

def handle_target(event)
    message, author, command = parse_dm(:target, event)

    return unless command.length == 3

    server = command[1]
    return if server.to_i != $server.id && server.downcase != $server.name.downcase
    $gamer_rules = [Rule.new(type: :user, id: command[2])]
end