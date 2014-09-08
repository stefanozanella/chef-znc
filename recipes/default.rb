#
# Cookbook Name:: znc
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
::Chef::Resource::Template.send :include, ZNC::Helper

raise unless node['znc']['user']

include_recipe 'yum-epel::default'

package 'znc'

config_dir = "/var/lib/znc/.znc/configs"

directory config_dir do
  user 'znc'
  group 'znc'
  recursive true
end

template "#{config_dir}/znc.conf" do
  user 'znc'
  group 'znc'
  source "znc.conf.erb"
  variables({
    port: node['znc']['port'],
    user: node['znc']['user'],
    salt: node['znc']['salt'],
    pass: hashed_pass(node['znc']['pass'], node['znc']['salt']),
  })
  notifies :restart, "service[znc]", :immediately
end

service 'znc' do
  action [:enable, :start]
  supports restart: true
end
