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
