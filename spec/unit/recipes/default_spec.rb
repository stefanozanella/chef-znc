require 'spec_helper'

describe "znc::default" do
  let(:chef_run) { ChefSpec::Runner.new.converge described_recipe }

  it "creates the directory containing the configuration" do
    expect(chef_run).to create_directory('/var/lib/znc/.znc/configs').with(
      user: 'znc',
      group: 'znc',
      recursive: true
    )
  end

  describe "the main config file" do
    it "is installed" do
      expect(chef_run).to create_template('/var/lib/znc/.znc/configs/znc.conf').with(
        user: 'znc',
        group: 'znc'
      )
    end

    it "contains the mandatory stanzas" do
      expect(chef_run).to render_file('/var/lib/znc/.znc/configs/znc.conf')
        .with_content(%r{^Version = 1.4$})
        .with_content(%r{<Listener \S*>[\S\s]*</Listener>})
    end

    it "contains the default options" do
      expect(chef_run).to render_file('/var/lib/znc/.znc/configs/znc.conf')
        .with_content(%r{Port = 1025})
    end

    xit "fails if an user attribute is not provided" do
    end
  end
end
