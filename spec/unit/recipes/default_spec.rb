require 'spec_helper'

describe "znc::default" do
  let(:chef_run) { ChefSpec::Runner.new.converge described_recipe }

  it "creates the directory containing the configuration" do
    expect(chef_run).to create_directory('/var/lib/znc/.znc/configs').with(
      recursive: true
    )
  end

  it "installs the main config file" do
    expect(chef_run).to create_template '/var/lib/znc/.znc/configs/znc.conf'
  end
end
