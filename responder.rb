require_relative 'responses'

class Responder
    def initialize(client, timeout)
        @client = client
        @timeout = timeout
        @id_mutex = Mutex.new
        @typing_mutex = Mutex.new
        @current_id = nil
        @handlers = []
    end

    def listen(channel)
        # Initial "bait" message
        message = INITIAL_MESSAGES.sample
        puts "Initial message: #{message}"
        channel.start_typing
        sleep rand(2..7)
        channel.send_message(message, tts = true)

        @handlers.append @client.mention(in: channel) {|event|
            handle_mention event
        }

        @handlers.append @client.message(in: channel) {|event|
            handle_message event
        }

        loop do
            time = Time.now + @timeout
            until @message_received do
                return if Time.now > time

                sleep 60
            end

            @message_received = false
        end
    end

    def destruct()
        @handlers.each do |handler|
            @client.remove_handler handler
        end
    end

    private
    def handle_mention(event)
        @message_received = true
        
        # Make sure we don't respond to the same message twice.
        @id_mutex.synchronize do
            return if @current_id == event.message.id
            @current_id = event.message.id
        end

        author = event.author
        $blacklist.each do |rule|
            if rule.match? author then
                puts
                puts "Blacklisted from #{author.username}##{author.discriminator}: #{rule}"
                return
            end
        end

        channel = event.channel
        message = event.message
        reply = get_reply message
        puts
        puts "Message received: #{message}"
        puts "Reply: #{reply}"
        return unless reply

        # Make sure multiple messages aren't sent with the same typing time.
        @typing_mutex.synchronize do
            # Typing/reading time to "humanize" the bot
            sleep rand(1..3)
            channel.start_typing
            sleep rand(2..5)
            channel.start_typing
            sleep rand(0..2)

            begin
                message.reply!(reply, mention_user: true, tts: true)
            rescue
                channel.send_message(reply, tts = true)
            end

            sleep channel.slowmode_rate
        end
    end

    def handle_message(event)
        author = event.author

        $target_rules.each do |rule|
            if rule.match? author then
                return handle_mention event
            end
        end
    end
end
