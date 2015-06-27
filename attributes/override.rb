#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

logstash_instance = node['mconf-stats']['logstash']['instance_name']
override['logstash']['instance'][logstash_instance]['user']           = node['mconf-stats']['logstash']['user']
override['logstash']['instance'][logstash_instance]['group']          = node['mconf-stats']['logstash']['group']
override['logstash']['instance'][logstash_instance]['supervisor_gid'] = node['mconf-stats']['logstash']['group']
override['logstash']['instance'][logstash_instance]['debug']          = node['mconf-stats']['logstash']['debug']
override['logstash']['instance'][logstash_instance]['install_type']   = node['mconf-stats']['logstash']['install_type']
override['logstash']['instance'][logstash_instance]['version']        = node['mconf-stats']['logstash']['version']
override['logstash']['instance'][logstash_instance]['source_url']     = node['mconf-stats']['logstash']['source_url']
override['logstash']['instance'][logstash_instance]['checksum']       = node['mconf-stats']['logstash']['checksum']
override['logstash']['instance'][logstash_instance]['xms']            = node['mconf-stats']['logstash']['xms']
override['logstash']['instance'][logstash_instance]['xmx']            = node['mconf-stats']['logstash']['xmx']
override['logstash']['instance'][logstash_instance]['log_file']       = node['mconf-stats']['logstash']['log_file']
override['logstash']['instance'][logstash_instance]['basedir']        = node['mconf-stats']['logstash']['basedir']

# Some options we just copy from the defaults in the logstash cookbook
override['logstash']['instance'][logstash_instance]['workers']           = node['logstash']['instance_default']['workers']
override['logstash']['instance'][logstash_instance]['limit_nofile_soft'] = node['logstash']['instance_default']['limit_nofile_soft']
override['logstash']['instance'][logstash_instance]['limit_nofile_hard'] = node['logstash']['instance_default']['limit_nofile_hard']
override['logstash']['instance'][logstash_instance]['gc_opts']           = node['logstash']['instance_default']['gc_opts']
override['logstash']['instance'][logstash_instance]['java_opts']         = node['logstash']['instance_default']['java_opts']
override['logstash']['instance'][logstash_instance]['ipv4_only']         = node['logstash']['instance_default']['ipv4_only']

override['elasticsearch']['version']          = node['mconf-stats']['elasticsearch']['version']
override['elasticsearch']['allocated_memory'] = node['mconf-stats']['elasticsearch']['allocated_memory']
override['elasticsearch']['http']['port']     = node['mconf-stats']['elasticsearch']['http']['port']
override['elasticsearch']['user']             = node['mconf-stats']['elasticsearch']['user']
override['elasticsearch']['cluster']['name']  = node['mconf-stats']['elasticsearch']['cluster']['name']

override['elasticsearch']['discovery']['zen']['ping']['multicast']['enabled'] = false
override['elasticsearch']['skip_start']               = false
override['elasticsearch']['skip_restart']             = false
override['elasticsearch']['transport']['tcp']['port'] = "9300-9400"

# TODO: need an easy way to turn DEBUG mode on
# override['elasticsearch']['logging']['index.search.slowlog']   = "DEBUG"
# override['elasticsearch']['logging']['index.indexing.slowlog'] = "DEBUG"
# override['elasticsearch']['logging']['org.apache.http'] = "INFO"

# To prevent an error in the elasticsearch cookbook
override['elasticsearch']['nginx']['ssl'] = {}


# Kibana
override['kibana']['version']                = "#{node['mconf-stats']['kibana']['version']}-linux-x64"
override['kibana']['java_webserver_port']    = node['mconf-stats']['kibana']['port']
override['kibana']['webserver_port']         = node['mconf-stats']['kibana']['http_port']
override['kibana']['install_path']           = node['mconf-stats']['kibana']['basedir']
override['kibana']['user']                   = node['mconf-stats']['kibana']['user']
override['kibana']['group']                  = node['mconf-stats']['kibana']['group']
override['kibana']['config']['kibana_index'] = node['mconf-stats']['kibana']['es_index']

override['kibana']['install_type']           = 'file'
override['kibana']['file']['type']           = 'tgz'
override['kibana']['file']['url']            = "https://download.elastic.co/kibana/kibana/kibana-#{node['kibana']['version']}.tar.gz"
override['kibana']['file']['checksum']       = '597e1b1e381b9a9ed9f8a66e115ec4d7a0258fa36c81fe74f1e91b651fcd567a'
override['kibana']['file']['config']         = 'config/kibana.yml' # relative path of config file
override['kibana']['install_java']           = false
# override['kibana']['file']['config_template']          = 'kibana.yml.erb' # template to use for config
# override['kibana']['file']['config_template_cookbook'] = 'kibana_lwrp' # cookbook containing config template

override['kibana']['webserver']          = 'nginx' # nginx or apache
override['kibana']['webserver_scheme']   = 'http://'
# override['kibana']['webserver_hostname'] = node.name
# override['kibana']['webserver_aliases']  = [node['ipaddress']]
# override['kibana']['webserver_listen']   = node['ipaddress']

override['kibana']['es_server']          = '127.0.0.1'
override['kibana']['es_port']            = node['mconf-stats']['elasticsearch']['http']['port']
# override['kibana']['es_role']            = 'elasticsearch_server'
# override['kibana']['es_scheme']          = 'http://'


# Logstash-forwarder
default['logstash-forwarder']['service_name']     = node['mconf-stats']['logstash-forwarder']['service_name']
default['logstash-forwarder']['logstash_servers'] = node['mconf-stats']['logstash-forwarder']['logstash_servers']
default['logstash-forwarder']['timeout']          = node['mconf-stats']['logstash-forwarder']['timeout']
default['logstash-forwarder']['config_path']      = node['mconf-stats']['logstash-forwarder']['config_path']
default['logstash-forwarder']['version']          = node['mconf-stats']['logstash-forwarder']['version']
default['logstash-forwarder']['ssl_ca']           = "#{node['mconf-stats']['logstash-forwarder']['certificate_path']}/#{node['mconf-stats']['logstash-forwarder']['ssl_certificate']}"
