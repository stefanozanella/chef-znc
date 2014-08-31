require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = "/sbin:/usr/sbin"
  end
end

describe "ZNC" do
  it "it is enabled as a service" do
    expect(service("znc")).to be_enabled
  end
end
