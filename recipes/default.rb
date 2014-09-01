#
# Cookbook Name:: znc
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'yum-epel::default'

package 'znc'

service 'znc' do
  action :enable
end

config_dir = "/var/lib/znc/.znc/configs"

directory config_dir do
  recursive true
end

template "#{config_dir}/znc.conf" do
  source "znc.conf.erb"
end
