#
# Cookbook Name:: znc
# Recipe:: default
#
# Copyright (C) 2014 YOUR_NAME
#
# All rights reserved - Do Not Redistribute
#
raise if !node['znc']['users'] || node['znc']['users'].empty?

include_recipe 'yum-epel::default'

package 'znc'

config_dir = "/var/lib/znc/.znc/configs"

directory config_dir do
  user 'znc'
  group 'znc'
  recursive true
end

::Chef::Resource::Template.send :include, ZNC::Helper

template "#{config_dir}/znc.conf" do
  user 'znc'
  group 'znc'
  source "znc.conf.erb"
  variables({
    port: node['znc']['port'],
    users: formatted_users_config(node['znc']['users']),
  })
  notifies :restart, "service[znc]", :immediately
end

service 'znc' do
  action [:enable, :start]
  supports restart: true
end
