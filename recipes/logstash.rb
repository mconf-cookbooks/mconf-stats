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

instance_name = node['mconf-stats']['logstash']['instance_name']
instance_configs = node['logstash']['instance'][instance_name]
service_name = "logstash_#{instance_name}"
home = node['mconf-stats']['logstash']['instance_home']
conf_dir = node['mconf-stats']['logstash']['instance_conf']
migration_dir = node['mconf-stats']['logstash']['migration_dir']

logstash_instance instance_name do
  create_account true
  action         :create
end

args      = ['agent', '-f', conf_dir]
args.concat ['-l', "#{home}/log/#{instance_configs['log_file']}"]
args.concat ['-w', instance_configs['workers'].to_s]
args.concat ['-vv'] if instance_configs['debug']
template "/etc/init/#{service_name}.conf" do
  mode      '0644'
  source    "logstash/upstart.conf.erb"
  variables(
    nofile_soft: instance_configs['limit_nofile_soft'],
    nofile_hard: instance_configs['limit_nofile_hard'],
    home: home,
    user: instance_configs['user'],
    supervisor_gid: instance_configs['supervisor_gid'],
    max_heap: instance_configs['xmx'],
    min_heap: instance_configs['xms'],
    args: args,
    gc_opts: instance_configs['gc_opts'],
    java_opts: instance_configs['java_opts'],
    ipv4_only: instance_configs['ipv4_only']
  )
  notifies :restart, "service[#{service_name}]", :delayed
end

service service_name do
  provider Chef::Provider::Service::Upstart
  supports restart: true, reload: true, status: false
  action [:enable, :start]
end

# Setup the secrets for lumberjack
# It will only setup if the data bags with the secrets exist, otherwise won't do anything
node.run_state['logstash_service'] = service_name
include_recipe "mconf-stats::_lumberjack_certificates"

# Copy user configuration files, if any
remote_directory conf_dir do
  source node['mconf-stats']['logstash']['user_configs']
  owner instance_configs['user']
  group instance_configs['group']
  mode '0755'
  files_mode '0660'
  files_owner instance_configs['user']
  files_group instance_configs['group']
  purge true
  action :create
  not_if { node['mconf-stats']['logstash']['user_configs'].nil? }
end

node['mconf-stats']['logstash']['plugins'].each do |plugin|
  execute "sudo -u #{instance_configs['user']} #{home}/bin/plugin install #{plugin}"
end

# Copy user migration files, if any
remote_directory migration_dir do
  source node['mconf-stats']['logstash']['migration_configs']
  owner instance_configs['user']
  group instance_configs['group']
  mode '0755'
  files_mode '0660'
  files_owner instance_configs['user']
  files_group instance_configs['group']
  purge true
  action :create
  not_if { node['mconf-stats']['logstash']['migration_configs'].nil? }
end

Chef::Log.info('Running logstash with ElasticSearch migration files')
execute "migrations" do
  command "sudo -u #{node['mconf-stats']['logstash']['user']} #{home}/bin/logstash agent -f #{node['mconf-stats']['logstash']['migration_dir']}"
  not_if { node['mconf-stats']['logstash']['migration_configs'].nil? }
end
