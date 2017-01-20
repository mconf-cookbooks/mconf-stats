#
# Cookbook Name:: mconf-stats
# Recipe:: default
# Author:: Leonardo Crauss Daronco (<daronco@mconf.org>)
# Modified by: Kazuki Yokoyama (<yokoyama.km@gmail.com>)
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

kibana_bin = "#{node['kibana']['install_dir']}/current/bin/kibana"

# Uses variables and template from kibana_lwrp
template kibana_config do
  source node['kibana'][install_type]['config_template']
  mode '0644'
  user node['kibana']['user']
  group node['kibana']['group']
  variables(
    server_port: node['kibana']['java_webserver_port'],
    server_host: node['mconf-stats']['kibana']['bind_interface'],
    elasticsearch_url: es_server,
    kibana_index: node['kibana']['config']['kibana_index']
  )
end

# Create the directory for the logfile
directory File.join(node['kibana']['install_dir'], 'current', 'log') do
  owner node['mconf-stats']['kibana']['user']
  group node['mconf-stats']['kibana']['group']
  mode '0755'
  recursive true
  action :create
end

# Service is taken mostly from the cookbook 'kibana' (not 'kibana_lwrp')
service 'kibana' do
  supports start: true, restart: true, reload: true, stop: true, status: true
  action :nothing
end

template '/etc/systemd/system/kibana.service' do
  source 'kibana/kibana.service.erb'
  variables(
    user: node['mconf-stats']['kibana']['user'],
    group: node['mconf-stats']['kibana']['group'],
    kibana_bin: kibana_bin,
    kibana_config: kibana_config
  )
  notifies :restart, 'service[kibana]', :delayed
end

# Accept data bags to populate Kibana
bag_name = node['mconf-stats']['kibana']['data_bag']
begin
  kibana_bag = Chef::DataBag.load(bag_name)
  require 'json'
rescue
  kibana_bag = []
  Chef::Log.warn("Could not find unencrypted data bag #{bag_name}")
end
kibana_bag.each_pair do |name, url|
  items = Chef::DataBagItem.load(bag_name, name)
  # so we get only the data we need, not all object
  items = items.to_hash

  input_file = ::File.join(Chef::Config[:file_cache_path], "kibana-seed-#{name}.json")
  file input_file do
    content items.to_json.to_s
  end

  bash "load kibana item #{name}" do
    code Elasticdump.import_cmd(input_file,
                                es_server,
                                node['mconf-stats']['kibana']['es_index'])
    action :run
  end
end

# In the newest versions of kibana this file is created and used in the initialization
# of the instance. But the last version of the cookbook don't treat this file very well.
# So we need to change the owner of this file.

# The file doesn't exists until the first restart. So if the file is not there we need
# to restart to make the alterations.
if !File.exist?('/opt/kibana/current/optimize/.babelcache.json')
  service 'kibana' do
    action :restart
  end
end
if File.exist?('/opt/kibana/current/optimize/.babelcache.json')
  execute "fixup kibana/optimize/.babelcache.json owner" do
   command "chown -R kibana:root /opt/kibana/current/optimize/.babelcache.json"
  end
end
