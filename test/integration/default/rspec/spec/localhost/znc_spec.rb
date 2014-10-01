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
      expect(irc_log).to match znc_welcome_message
    end
  end

  it "connects the user to its configured network" do
    irc_log = simulate_irc_connection('localhost', port, "user_with_network", "random_pass")
    expect(irc_log).to match freenode_welcome_message
  end

  it "automatically joins all the channels configured for the user network" do
    irc_log = simulate_irc_connection('localhost', port, "user_with_network_and_channels", "random_pass")
    expect(irc_log).to match join_confirmation_for("#test_chef_znc_channel_1")
    expect(irc_log).to match join_confirmation_for("#test_chef_znc_channel_2")
  end
end
