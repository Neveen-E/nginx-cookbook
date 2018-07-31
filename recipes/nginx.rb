#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
apt_update 'update_sources' do
  action :update
end

package 'nginx'

service 'nginx' do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  notifies :restart , 'service[nginx]'
end

template '/etc/nginx/sites-available/proxy.conf' do
  source 'proxy.conf.erb'
  notifies :reload , 'service[nginx]'
end

link '/etc/nginx/sites-enabled/proxy.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
  notifies :restart, 'service[nginx]'
end

link '/etc/nginx/sites-enabled/default' do
  action :delete
  notifies :restart, 'service[nginx]'
end
