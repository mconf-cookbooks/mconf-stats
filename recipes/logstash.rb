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

# Setup service settings
instance_name = node['mconf-stats']['logstash']['instance_name']
instance_configs = node['logstash']['instance'][instance_name]
service_name = "logstash_#{instance_name}"

# Setup paths settings
home = node['mconf-stats']['logstash']['instance_home']
bin_dir = node['mconf-stats']['logstash']['instance_bin']
conf_dir = node['mconf-stats']['logstash']['instance_conf']
log_dir = node['mconf-stats']['logstash']['instance_log']
config_dir = node['mconf-stats']['logstash']['instance_config']
template_dir = node['mconf-stats']['logstash']['instance_template']
migration_dir = node['mconf-stats']['logstash']['migration_dir']

# Setup files settings
logstash_conf = ::File.join(config_dir, "logstash.yml")
jvm_conf = ::File.join(config_dir, "jvm.options")
startup_conf = ::File.join(config_dir, "startup.options")

# Setup Elasticsearch settings
es_server = node['mconf-stats']['logstash']['es_server']
es_port = node['mconf-stats']['logstash']['es_port']
es_index = node['mconf-stats']['logstash']['es_index']
es_template = node['mconf-stats']['logstash']['es_template']
es_template_file = "#{es_template}.json"
es_template_path = ::File.join(template_dir, es_template_file)

# Create Logstash instance using chef-logstash cookbook resource
logstash_instance instance_name do
  create_account true
  action :create
end

# logstash_instance creates unnecessary 'log' directory
# Logstash tarball already has its own 'logs' directory
directory "#{home}/log" do
  action :delete
end

# Install template for Logstash main configuration file
template logstash_conf do
  mode '0644'
  source "logstash/logstash.yml.erb"
  variables(
    path_conf: conf_dir,
    path_log: log_dir
  )
end

# Install template for Logstash JVM configuration file
template jvm_conf do
  mode '0644'
  source "logstash/jvm.options.erb"
end

# Install template for Logstash startup configuration file
template startup_conf do
  mode '0644'
  source "logstash/startup.options.erb"
  variables(
    ls_home: home,
    ls_user: instance_configs['user'],
    ls_group: instance_configs['group'],
    service_name: service_name
  )
  notifies :run, "execute[system-install]", :immediately
end

# Execute system-install.sh script in order to create Logstash service in OS
# based on startup.options configuration file.
execute 'system-install' do
  command "#{bin_dir}/system-install"
  action :nothing
  notifies :restart, "service[#{service_name}]", :delayed
end

# Setup Logstash service and start it
service service_name do
  supports restart: true, reload: true, status: false
  action [:enable, :start]
end

# Setup the secrets for Lumberjack
# It will only setup if the data bags with the secrets exist, otherwise won't do anything
node.run_state['logstash_service'] = service_name
include_recipe "mconf-stats::_lumberjack_certificates"

# Copy user configuration files (inputs, filters and outputs), if any
# These configuration files should not have any dynamic attribute such as
# Elasticsearch server address
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

# Install template for configuration files (inputs, filters and outputs) that
# have dynamic attributes such as Elasticsearch server address

# Copy '01-input-beats.conf' template
template "#{conf_dir}/01-input-beats-teste.conf" do
  source "logstash/logstash_configs/01-input-beats.conf.erb"
  mode '0660'
  user instance_configs['user']
  group instance_configs['group']
  variables(
    ssl_certificate: node.run_state['certificate_path'],
    ssl_key: node.run_state['key_path'],
    ssl_ca: node.run_state['ca_path'].first
  )
end

# Copy '12-filter-elasticsearch-xml_cdr.conf' template
template "#{conf_dir}/12-filter-freeswitch-xml_cdr-teste.conf" do
  source "logstash/logstash_configs/12-filter-freeswitch-xml_cdr.conf.erb"
  mode '0660'
  user instance_configs['user']
  group instance_configs['group']
  variables(
    es_server: es_server,
    es_port: es_port
  )
end

# Copy '23-output-elasticsearch.conf' template
template "#{conf_dir}/23-output-elasticsearch-teste.conf" do
  source "logstash/logstash_configs/23-output-elasticsearch.conf.erb"
  mode '0660'
  user instance_configs['user']
  group instance_configs['group']
  variables(
    es_server: es_server,
    es_port: es_port,
    es_index: es_index,
    es_template_path: es_template_path,
    es_template: es_template
  )
end

# Copy user index template files, if any
# These are mainly used for setting mappings
remote_directory template_dir do
  source node['mconf-stats']['logstash']['user_templates']
  owner instance_configs['user']
  group instance_configs['group']
  mode '0755'
  files_mode '0660'
  files_owner instance_configs['user']
  files_group instance_configs['group']
  purge true
  action :create
  not_if { node['mconf-stats']['logstash']['user_templates'].nil? }
end

# Install plugins for Logstash
# It only will install the plugins if exists any plugin name in the plugins node
node['mconf-stats']['logstash']['plugins'].each do |plugin|
  execute "installing plugin #{plugin}" do
    command "sudo ./logstash-plugin install #{plugin}"
    cwd "#{bin_dir}"
  end
end

# If any modification in Elasticsearch data was needed due any new info inserted on
# the Logstash filters, a migration file must be made. This files must located all entries
# that need to be changed, making the changes, then, update the entries.

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

# Run a single instance of Logstash with the configs located into the migration directory
# created or updated in the command above. After finished the run the instance ends.
Chef::Log.info('Running logstash with ElasticSearch migration files')
execute "migrations" do
  command "sudo -u #{node['mconf-stats']['logstash']['user']} #{bin_dir}/logstash agent -f #{node['mconf-stats']['logstash']['migration_dir']}"
  not_if { node['mconf-stats']['logstash']['migration_configs'].nil? }
end

# Always restart the service at the end of the recipe
service service_name do
  action :restart
end
