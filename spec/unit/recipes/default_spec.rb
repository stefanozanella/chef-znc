require 'spec_helper'

describe "znc::default" do
  let(:chef_run) { ChefSpec::Runner.new.converge described_recipe }

  it "installs the main config file" do
    expect(chef_run).to create_template '/var/lib/znc/.znc/configs/znc.conf'
  end
end
