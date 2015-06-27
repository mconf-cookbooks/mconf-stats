#
# Cookbook Name:: mconf-stats
# Recipe:: default
# Author:: Leonardo Crauss Daronco (<daronco@mconf.org>)
#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

install_type = 'file'

group node['kibana']['group']

user node['kibana']['user'] do
  comment 'Kibana Server'
  gid node['kibana']['group']
  home node['kibana']['base_dir']
  shell '/bin/bash'
  system true
end

kibana_install 'kibana' do
  user node['kibana']['user']
  group node['kibana']['group']
  install_dir node['kibana']['install_dir']
  install_type install_type
  action :create
end

# These are defaults in kibana_lwrp
docroot = "#{node['kibana']['install_dir']}/current/kibana"
kibana_config = "#{node['kibana']['install_dir']}/current/#{node['kibana'][install_type]['config']}"
es_server = "#{node['kibana']['es_scheme']}#{node['kibana']['es_server']}:#{node['kibana']['es_port']}"

# Uses variables and template from kibana_lwrp
template kibana_config do
  source node['kibana'][install_type]['config_template']
  cookbook node['kibana'][install_type]['config_template_cookbook']
  mode '0644'
  user node['kibana']['user']
  group node['kibana']['group']
  variables(
    index: node['kibana']['config']['kibana_index'],
    port: node['kibana']['java_webserver_port'],
    elasticsearch: es_server,
    default_route: node['kibana']['config']['default_route'],
    panel_names:  node['kibana']['config']['panel_names']
  )
end

# Uses variables and template from kibana_lwrp
kibana_web 'kibana' do
  type lazy { node['kibana']['webserver'] }
  docroot docroot
  es_server node['kibana']['es_server']
  kibana_port node['kibana']['java_webserver_port']
  template 'kibana-nginx_file.conf.erb'
  not_if { node['kibana']['webserver'] == '' }
end

# Service is taken mostly from the cookbook 'kibana' (not 'kibana_lwrp')
service 'kibana' do
  provider Chef::Provider::Service::Upstart
  supports start: true, restart: true, stop: true, status: true
  action :nothing
end
template '/etc/init/kibana.conf' do
  cookbook 'mconf-stats'
  source 'kibana/upstart.conf.erb'
  variables(
    user: node['kibana']['user'],
    group: node['kibana']['group'],
    dir: node['kibana']['install_dir'],
    port: node['mconf-stats']['kibana']['port'],
    options: ''
  )
  notifies :restart, 'service[kibana]', :delayed
end
