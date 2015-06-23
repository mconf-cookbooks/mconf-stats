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
service_name = "logstash_#{instance_name}"
home = "#{node['mconf-stats']['logstash']['basedir']}/#{instance_name}"
conf_dir = "#{home}/etc/conf.d"
instance_configs = node['logstash']['instance'][instance_name]

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
  source    "upstart/logstash.erb"
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


configs_created = []

node['mconf-stats']['logstash']['inputs'].each do |config|
  tmpl = template "#{conf_dir}/#{config[:name]}" do
    source    'logstash/input_file.conf.erb'
    owner     instance_configs['user']
    group     instance_configs['group']
    mode      '0644'
    variables config
    action    :create
    notifies  :restart, "service[#{service_name}]", :delayed
  end
  configs_created << tmpl.name
end

node['mconf-stats']['logstash']['outputs']['elasticsearch'].each do |config|
  tmpl = template "#{conf_dir}/#{config[:name]}" do
    source    'logstash/output_elasticsearch.conf.erb'
    owner     instance_configs['user']
    group     instance_configs['group']
    mode      '0644'
    variables config
    action    :create
    notifies  :restart, "service[#{service_name}]", :delayed
  end
  configs_created << tmpl.name
end

unless node['mconf-stats']['logstash']['outputs']['stdout'].empty?
  config = node['mconf-stats']['logstash']['outputs']['stdout']
  tmpl = template "#{conf_dir}/#{config[:name]}" do
    source    'logstash/output_stdout.conf.erb'
    owner     instance_configs['user']
    group     instance_configs['group']
    mode      '0644'
    variables config
    action    :create
    notifies  :restart, "service[#{service_name}]", :delayed
  end
  configs_created << tmpl.name
end

# Remove old configs we didn't create
Dir["#{conf_dir}/*"].each do |path|
  file path do
    action :delete
    not_if { configs_created.include?(path) }
  end
end

# logstash_pattern name do
#   action [:create]
# end
