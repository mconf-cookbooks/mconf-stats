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

%W{git #{node['mconf-stats']['java_pkg']}}.each do |pkg|
  package pkg
end

# Logstash

logstash_name = 'mconf'
logstash_service_name = "logstash_#{logstash_name}"
logstash_home = "#{node['logstash']['instance_default']['basedir']}/#{logstash_name}"
logstash_conf_dir = "#{logstash_home}/etc/conf.d"

logstash_instance logstash_name do
  create_account true
  action         :create
end


args      = ['agent', '-f', logstash_conf_dir]
args.concat ['-l', "#{logstash_home}/log/#{node['logstash']['instance_default']['log_file']}"]
args.concat ['-w', node['logstash']['instance_default']['workers'].to_s]
args.concat ['-vv'] if node['logstash']['instance_default']['debug']
template "/etc/init/#{logstash_service_name}.conf" do
  mode      '0644'
  source    "upstart/logstash.erb"
  variables(
    nofile_soft: node['logstash']['instance_default']['limit_nofile_soft'],
    nofile_hard: node['logstash']['instance_default']['limit_nofile_hard'],
    home: logstash_home,
    user: node['logstash']['instance_default']['user'],
    supervisor_gid: node['logstash']['instance_default']['supervisor_gid'],
    max_heap: node['logstash']['instance_default']['xmx'],
    min_heap: node['logstash']['instance_default']['xms'],
    args: args,
    gc_opts: node['logstash']['instance_default']['gc_opts'],
    java_opts: node['logstash']['instance_default']['java_opts'],
    ipv4_only: node['logstash']['instance_default']['ipv4_only']
  )
  notifies :restart, "service[#{logstash_service_name}]", :delayed
end

service logstash_service_name do
  provider Chef::Provider::Service::Upstart
  supports restart: true, reload: true, status: false
  action [:enable, :start]
end


configs_created= []

node['mconf-stats']['logstash']['inputs'].each do |config|
  tmpl = template "#{logstash_conf_dir}/#{config[:name]}" do
    source 'logstash/input_file.conf.erb'
    owner       node['logstash']['instance_default']['user']
    group       node['logstash']['instance_default']['group']
    mode        '0644'
    variables   config
    action      :create
    notifies    :restart, "service[#{logstash_service_name}]"
  end
  configs_created << tmpl.name
end

node['mconf-stats']['logstash']['outputs']['elasticsearch'].each do |config|
  tmpl = template "#{logstash_conf_dir}/#{config[:name]}" do
    source 'logstash/output_elasticsearch.conf.erb'
    owner       node['logstash']['instance_default']['user']
    group       node['logstash']['instance_default']['group']
    mode        '0644'
    variables   config
    action      :create
    notifies    :restart, "service[#{logstash_service_name}]"
  end
  configs_created << tmpl.name
end

# Remove old configs we didn't create
Dir["#{logstash_conf_dir}/*.conf"].each do |path|
  file path do
    action :delete
    not_if { configs_created.include?(path) }
  end
end

# logstash_pattern name do
#   action [:create]
# end
