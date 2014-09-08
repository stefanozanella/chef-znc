require 'spec_helper'

describe "znc::default" do
  let(:nick)        { "test_user" }
  let(:salt)        { "12345678901234567890" }
  let(:pass)        { "test_pass" }
  let(:hashed_pass) { Digest::SHA256.new.hexdigest "#{pass}#{salt}" }

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['znc']['user'] = nick
      node.set['znc']['pass'] = pass
      node.set['znc']['salt'] = salt
    end.converge described_recipe
  end

  it "creates the directory containing the configuration" do
    expect(chef_run).to create_directory('/var/lib/znc/.znc/configs').with(
      user: 'znc',
      group: 'znc',
      recursive: true
    )
  end

  describe "the main config file" do
    let(:config_file) { '/var/lib/znc/.znc/configs/znc.conf' }

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

    it "configures the `user` stanza" do
      expect(chef_run).to render_file(config_file)
        .with_content(%r{<User #{nick}>[\S\s]*</User>})
        .with_content(%r{<Pass password>[\S\s]*</Pass>})
        .with_content(%r{Method = SHA256+})
        .with_content(%r{Salt = #{salt}})
        .with_content(%r{Hash = #{hashed_pass}})
    end
  end

  describe "errors" do
    let(:chef_run) { ChefSpec::Runner.new.converge described_recipe }

    it "fails if the IRC user is not provided" do
      expect { chef_run }.to raise_error
    end
  end
end
