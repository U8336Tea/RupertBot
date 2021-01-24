#TODO: Maybe put these in a config file too?
INITIAL_MESSAGES = [
    "G\\*ming was invented by Adolf Hitler. Prove me wrong.",
    "All g\\*mers are Nazis. This is a proven fact.",
    "What's the difference between a g\\*mer and a pedophile? There is none! :rofl:",
    "@everyone Nazi g\\*mers can KISS MY ASS!",
    "Dear g\\*mers: No one likes you.",
    "Dear g\\*mers: Why are you Nazis?",
    "G\\*MERS ARE NOT WELCOME ON FACEBOOK!",
    "Begone, g\\*mers. You aren't welcome here.",
    "The only difference between a g\\*mer and a b\\*g g\\*mer is the b\\*g g\\*mers are more honest.",
    "There is not one good g\\*mer. No, not one.",
    "AGAB ALL G\\*MERS ARE BASTARDS",
    "ALL G\\*MERS ARE NAZIS.",
    "G\\*mers are going to the lowest depths of hell.",
    "Get a life and stop g\\*ming.",
    "Dear g\\*mers: Go outside for once instead of hating minorities.",
    "Fortnite is objectively better than Mein Kraft because Mein Kraft was written by Hitler.",
    "G\\*mers: please shut the fuck up for once. I mean seriously, you never fucking shut up.",
    "G\\*mers: Please get an actual argument so we don't have to keep fucking repeating ourselves."
]

RESPONSES = [
    "Didn't ask.",
    "Didn't......ask?",
    "Did not ask.",
    "Don't care.",
    "Didn't read.",
    "Did not read! :rofl:",
    "TL;DR?",
    "tldr",
    "Ok and?",
    "Don't care; didn't ask.",
    "That's nice and all, but who asked?",
    "Yes, and?",
    "So?",
    "Keep crying, Nazi.",
    "Shut up, Nazi.",
    "All g\\*mers are liars.",
    "No.",
    "Proof?",
    "Source?",
    "Proof? Source?",
    "WROG!",
    "WROG",
    ":middle_finger:",
    "I don't give a shit.",
    "Fuck off Nazi.",
    "Cry harder Nazi.",
    "Do I look like I care, asshole?",
    "Stop lying.",
    "You're nitpicking and biased, i win bye bye",
    "Fuck you.",
    "Ok nazi.",
    "Gonna cry?",
    "Whatever you say, Adolf.",
    "Keep seething, Nazi.",
    "What the fuck does that have to do with anything?",
    "Bullshit.",
    "Bull fucking shit.",
    "your mom lol :rofl:",
    "I do solemnly swear that I will faithfully execute the office of g\\*mer destroyer of the United States, and will, to the best of my ability, preserve, protect, and defend the constitution of ANTIGA, so help me God!",
    "Anti-g\\*mers are wholesome chungus 100.",
    "G\\*mers are tikcringe wholesome 0 [Everybody hated that.]",
    "Creeper. Aw man. (g\\*mers are all creepers)",
    "Nope. You're wrog.",
    "Shut the fuck up shut up shut up shut up",
    "Problem?",
    "Ok and? Didn't ask.",
    "https://tenor.com/view/failure-fail-andy-the-office-gif-6079363",
    "https://tenor.com/view/spiderman-thats-it-gonna-cry-tobey-maguire-are-you-going-to-cry-gif-17698704",
    "https://tenor.com/view/cope-seethe-cope-cope-gif-19299672",
    "https://cdn.discordapp.com/attachments/743554243188752573/801709678471806976/image0.png",
    "https://cdn.discordapp.com/attachments/743554243188752573/802780481178566716/video0.mov"
]

TROLL_PASTA = 'No. This is not a satire.

No. We are not trolls.

No. We are not joking.

Decades ago, an evil rose from the shadows, invading every home of every Christian American family. It shattered our good and healthy ways to live, ruthlessly dragging the young folk to an abyss of filth, addiction and degeneration. Disguising itself as entertainment, this evil finally showed up its fangs, painted by innocent blood.

This evil is called video games.

Today, more and more people, calling themselves as "gamers" spend their lives in front of a screen, killing and torturing people for fun. Their eyes hurt and their fingers get tired, but they continue. "It is harmless", they say.

Gamers around the world reunite in "conventions" to talk about these vile creations that are videogames. They cheer and cackle like demons at the gate of hell while big and multi billionaire corporations fill their pockets, exploiting the pain of families victims of gamers.

While this happens, more and more blood flows between our streets. More and more children and schools are covered with screams of despair. Despair of those who are victims of the gamer.

But we resist. We will not fall. We will not perish. We will PREVAIL!

ANTI GAMERS, RISE UP!'

BOT_RESPONSES = [
    "Not a bot. Try again.",
    "Stop calling me a robot.",
    "Will you stop saying I'm a bot? Grow the hell up.",
    "I'm really getting tired of your incessant whining.",
    "Stop calling me a fucking robot.",
    "Quit saying I'm a bot and get an actual argument for once in your goddamn life.",
    "Whatever. :middle_finger:"
]

bot_count = -1

def get_reply(message)
    content = message.content.downcase
    if content.length < 3 || rand(0..127) == 0 # Message too short (Or randomly selected)
        return nil
    elsif content.include? ' bot' then
        return RESPONSES.sample if rand(0..7) == 0

        return BOT_RESPONSES.sample if bot_count >= BOT_RESPONSES.length
        
        bot_count += 1
        return BOT_RESPONSES[bot_count]
    elsif !content.match?(/[a-zA-Z]/) then # User sent a message like "..."
        return nil
    elsif content.include?('valid argument') || content.include?('actual argument') then
        return 'Okay. ' + INITIAL_MESSAGES.sample
    elsif content.include?(' troll') || content.include?(' satire')
        return RESPONSES.sample if rand(0..3) == 0

        # Looking up the copypasta time
        sleep 8
        return TROLL_PASTA
    elsif content.include? 'kill myself' then
        Thread.new do
            sleep 15
            exit 2
        end

        return 'If you are really suicidal, please leave here and seek professional help. It is not fair to us or to yourself to put that on us.'
    else
        return INITIAL_MESSAGES.sample if rand(0..63) == 0
        return RESPONSES.sample
    end
end
