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


# First map all config files we need to create
# Note: we add ".erb" to all template name because the logstash cookbook
# chomps the extension off and we want to keep the extension set by the user
configs_created = []
my_files = []

node['mconf-stats']['logstash']['inputs']['files'].each do |config|
  my_files << {
    'name' => config['name'],
    'variables' => config.to_hash,
    'template' => { "#{config['name']}.erb" => 'logstash/input_file.conf.erb' }
  }
end

unless node['mconf-stats']['logstash']['inputs']['lumberjack']['name'].nil?
  include_recipe "mconf-stats::_lumberjack_certificates"

  vars = node['mconf-stats']['logstash']['inputs']['lumberjack'].to_hash
  vars['ssl_certificate'] = "#{vars['certificate_path']}/#{vars['ssl_certificate']}"
  vars['ssl_key'] = "#{vars['certificate_path']}/#{vars['ssl_key']}"

  my_files << {
    'name' => vars['name'],
    'variables' => vars,
    'template' => { "#{vars['name']}.erb" => 'logstash/input_lumberjack.conf.erb' }
  }
end

node['mconf-stats']['logstash']['outputs']['elasticsearch'].each do |config|
  my_files << {
    'name' => config['name'],
    'variables' => config.to_hash,
    'template' => { "#{config['name']}.erb" => 'logstash/output_elasticsearch.conf.erb' }
  }
end

unless node['mconf-stats']['logstash']['outputs']['stdout'].empty?
  vars = node['mconf-stats']['logstash']['outputs']['stdout'].to_hash
  my_files << {
    'name' => vars['name'],
    'variables' => vars,
    'template' => { "#{vars['name']}.erb" => 'logstash/output_stdout.conf.erb' }
  }
end

# Create all config files using logstash
my_files.each do |my_config|
  tmpl = logstash_config my_config['name'] do
    instance instance_name
    templates my_config['template']
    variables my_config['variables']
    templates_cookbook 'mconf-stats'
    action :create
  end
  configs_created << tmpl.name
end

# Remove old configs we didn't create
Dir["#{conf_dir}/*"].each do |path|
  filename = ::File.basename(path)
  file path do
    action :delete
    not_if { configs_created.include?(filename) }
  end
end

# logstash_pattern name do
#   action [:create]
# end
