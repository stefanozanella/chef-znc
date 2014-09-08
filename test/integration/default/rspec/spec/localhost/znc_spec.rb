require 'spec_helper'

describe "ZNC" do
  it "it is running as a service" do
    expect(service("znc")).to be_running
  end

  it "it is enabled as a service" do
    expect(service("znc")).to be_enabled
  end

  it "allows the configured user to connect to it" do
    nick = "test_user"
    pass = "test_pass"
    port = 5432

    irc_log = simulate_irc_connection('localhost', port, nick, pass)
    expect(irc_log).to match %r{welcome to znc}i
  end
end
