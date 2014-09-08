require 'serverspec'

include SpecInfra::Helper::Exec
include SpecInfra::Helper::DetectOS

# See https://tickets.opscode.com/browse/CHEF-3304
Encoding.default_external = Encoding::UTF_8

def simulate_irc_connection(server, port, nick, pass)
  require 'irc-socket'

  irc = IRCSocket.open(server, port)

  if irc.connected?
    irc.pass pass
    irc.nick nick
    irc.user nick, 0, "*", nick

    irc.quit

    replies = ""
    while line = irc.read
      replies += line
    end

    replies
  end
end
