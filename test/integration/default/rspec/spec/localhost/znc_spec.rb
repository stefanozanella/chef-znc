require 'spec_helper'

describe "ZNC" do
  it "it is running as a service" do
    expect(service("znc")).to be_running
  end

  it "it is enabled as a service" do
    expect(service("znc")).to be_enabled
  end
end
