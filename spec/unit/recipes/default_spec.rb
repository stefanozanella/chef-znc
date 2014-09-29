require 'spec_helper'

describe "znc::default" do
  let(:config_dir)  { "/var/lib/znc/.znc/configs" }
  let(:nick)        { "test_user" }
  let(:other_nick)  { "other_user" }
  let(:salt)        { "12345678901234567890" }
  let(:pass)        { "test_pass" }
  let(:hashed_pass) { Digest::SHA256.new.hexdigest "#{pass}#{salt}" }

  let(:irc_network)         { "an_irc_server" }
  let(:irc_network_server)  { "an.irc.server" }
  let(:irc_network_port)    { 1234 }

  let(:irc_channel) { "#test_channel" }

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['znc']['users'] = [
        { nick: nick,         pass: pass,         salt: salt },
        { nick: other_nick,   pass: "not_tested", salt: "same" },

        { nick: "not_tested", pass: "not_tested", salt: "same",
          network: {
            server: irc_network_server,
            port: irc_network_port,
            channel: irc_channel } }
      ]
    end.converge described_recipe
  end

  it "creates the directory containing the configuration" do
    expect(chef_run).to create_directory(config_dir).with(
      user: 'znc',
      group: 'znc',
      recursive: true
    )
  end

  describe "the main config file" do
    let(:config_file) { "#{config_dir}/znc.conf" }

    it "is installed" do
      expect(chef_run).to create_template(config_file).with(
        user: 'znc',
        group: 'znc'
      )
    end

    it "contains the mandatory stanzas" do
      expect(chef_run).to render_file(config_file)
        .with_content(%r{^Version = 1.4$})
        .with_content(%r{<Listener \S*>[\S\s]*</Listener>})
    end

    it "contains the default options" do
      expect(chef_run).to render_file(config_file)
        .with_content(%r{Port = 1025})
    end

    it "configures an `user` stanza for each configured user" do
      expect(chef_run).to render_file(config_file)
        .with_content(%r{<User #{nick}>[\S\s]*</User>})
        .with_content(%r{<Pass password>[\S\s]*</Pass>})
        .with_content(%r{Method = SHA256+})
        .with_content(%r{Salt = #{salt}})
        .with_content(%r{Hash = #{hashed_pass}})
        .with_content(%r{<User #{other_nick}>[\S\s]*</User>})
    end

    it "configures the `network` stanza" do
      expect(chef_run).to render_file(config_file)
        .with_content(%r{<Network an_irc_server>[\S\s]*Server = an.irc.server[\S\s]*1234[\S\s]*</Network>})
    end

    it "configures the channel stanza for the network if a channel is provided" do
      expect(chef_run).to render_file(config_file)
        .with_content(%r{<Network an_irc_server>[\S\s]*<Chan #{irc_channel}>\s*</Chan>[\S\s]*</Network>})
    end

    context "when no channel is provided" do
      let(:chef_run) do
        ChefSpec::Runner.new do |node|
          node.set['znc']['users'] = [
            { nick: "not_tested", pass: "not_tested", salt: "same",
              network: {
              server: irc_network_server,
              port: irc_network_port } }
          ]
        end.converge described_recipe
      end

      it "doesn't configure the channel stanza for the network" do
        expect(chef_run).to_not render_file(config_file)
          .with_content(%r{<Chan[\S\s]*>\s*</Chan>})
      end
    end
  end

  describe "errors" do
    describe "when IRC user list is not provided" do
      let(:chef_run) { ChefSpec::Runner.new.converge described_recipe }

      it "reports an error" do
        expect { chef_run }.to raise_error
      end
    end

    describe "when IRC user list is empty" do
      let(:chef_run) do
        ChefSpec::Runner.new do |node|
          node.set['znc']['users'] = []
        end.converge described_recipe
      end

      it "reports an error" do
        expect { chef_run }.to raise_error
      end
    end
  end
end
