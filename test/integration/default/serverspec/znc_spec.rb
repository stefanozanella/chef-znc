require 'serverspec'

# See https://tickets.opscode.com/browse/CHEF-3304
Encoding.default_external = Encoding::UTF_8

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = "/sbin:/usr/sbin"
  end
end

describe "ZNC" do
  it "it is running as a service" do
    expect(service("znc")).to be_running
  end

  it "it is enabled as a service" do
    expect(service("znc")).to be_enabled
  end
end
