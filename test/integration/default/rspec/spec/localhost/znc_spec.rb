require 'spec_helper'

describe "ZNC" do
  let(:port) { 5432 }

  it "it is running as a service" do
    expect(service("znc")).to be_running
  end

  it "it is enabled as a service" do
    expect(service("znc")).to be_enabled
  end

  it "allows multiple users to connect to it" do
    [
      { nick: "test_user_1", pass: "test_pass_1" },
      { nick: "test_user_2", pass: "test_pass_2" },
    ].each do |user|
      irc_log = simulate_irc_connection('localhost', port, user[:nick], user[:pass])
      expect(irc_log).to match %r{welcome to znc}i
    end
  end

  it "connects the user to its configured network" do
    irc_log = simulate_irc_connection('localhost', port, "user_with_network", "random_pass")
    expect(irc_log).to match %r{welcome to the freenode internet relay chat network}i
  end

  it "automatically joins the channel configured for the user network" do
    irc_log = simulate_irc_connection('localhost', port, "user_with_network_and_channel", "random_pass")
    expect(irc_log).to match %r{blabla}i
  end
end
