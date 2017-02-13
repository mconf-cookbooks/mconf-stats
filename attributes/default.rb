#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

# Notes about the applications installed:
#
#   Logstash defaults
#
#   path: /opt/logstash/mconf/
#   bin: /opt/logstash/mconf/bin/
#   config: /opt/logstash/mconf/config/
#   configs: /opt/logstash/mconf/etc/conf.d/
#   logs: /opt/logstash/mconf/logs/
#   grok: /opt/logstash/mconf/patterns/
#   templates: /opt/logstash/mconf/templates/
#   init: /etc/systemd/system/logstash_mconf.service
#   default port for Lumberjack: 5960
#
#   Elasticsearch defaults
#
#   path: /usr/share/elasticsearch/
#   bin: /user/share/elasticsearch/bin/
#   logs: /var/log/elasticsearch
#   config: /etc/elasticsearch/
#   init: /etc/init.d/elasticsearch
#   default http port: 9200
#   default node ports: 9300-9400 (gets the first one that's free)
#
#   Kibana
#   path: /opt/kibana/current/
#   bin: /opt/kibana/current/bin/
#   config: /opt/kibana/current/config/
#   logs: /opt/kibana/current/log/
#   init: /etc/systemd/system/kibana.service
#   default port: 5601, 80

# Versions

# Logstash

# SHA256 of logstash-<version>.tar.gz files
default['mconf-stats']['logstash']['5.0.0']['checksum'] = 'b5ff5336a49540510f415479deb64566c3b2dad1ce8856dde3df3b6ca1aa8d90'
default['mconf-stats']['logstash']['5.0.1']['checksum'] = 'd4cb9a624e12f8e4cf852a251c96b371094009b84a85231c9604ba7d6523da4d'
default['mconf-stats']['logstash']['5.0.2']['checksum'] = 'eff45f965118b6ef767f719d85f6dbca438ea2daa5e901907a32fa5bf1a70d9c'
default['mconf-stats']['logstash']['5.1.1']['checksum'] = '9ce438ec331d3311acc55f22553a3f5a7eaea207b8aa2863164bb2767917de1f'
default['mconf-stats']['logstash']['5.1.2']['checksum'] = 'ffa4e370c6834f8e2591a23147a74a8cea04509efc6cf8c02b5cc563455c559c'
default['mconf-stats']['logstash']['5.2.0']['checksum'] = 'f371d20127fb9b34a6575ba0d69fa764df73718eda02adc177a85fd3117500f0'

# Kibana

# SHA256 of kibana-<version>-linux-x86_64.tar.gz files
default['mconf-stats']['kibana']['5.0.0']['checksum'] = '39cf5bc9e249df7ef98f0b7883f4ff23514a40290dfc48c5101b1d1ab67d60ae'
default['mconf-stats']['kibana']['5.0.1']['checksum'] = 'bf845a27d37c24a8d63f8407691001d3c8dd31d2317e6866a4473d421aa9acd9'
default['mconf-stats']['kibana']['5.0.2']['checksum'] = '90998b3dce006dc0193a9a65ef79e27514bcbdc4909e6215ae75fa5425b24e95'
default['mconf-stats']['kibana']['5.1.1']['checksum'] = 'da0383be8a12936c7d2a0a145e7bf0eb15abf972e585e0115ed8742032c79245'
default['mconf-stats']['kibana']['5.1.2']['checksum'] = 'c2e30b9581e7222e8f2536d4b08087dc282a6b31a24ec0e43b905507fe2f2b04'
default['mconf-stats']['kibana']['5.2.0']['checksum'] = '729af8ab00f719f2038f6c499e508744b274487756e0214b660535ebead6f28a'

# User and group on the server the application is being deployed
default['mconf-stats']['user']      = 'mconf'
default['mconf-stats']['app_group'] = 'www-data'
default['mconf-stats']['domain']    = '127.0.0.1'
default['mconf-stats']['java_pkg']  = 'openjdk-8-jre-headless'

# Logstash

# Logstash general settings
default['mconf-stats']['logstash']['user']          = 'logstash'
default['mconf-stats']['logstash']['group']         = 'logstash'
default['mconf-stats']['logstash']['debug']         = false
default['mconf-stats']['logstash']['xms']           = '1536M' # It's highly advised to set Xms and Xmx to the same value
default['mconf-stats']['logstash']['xmx']           = '1536M'
default['mconf-stats']['logstash']['log_file']      = 'logstash.log'
default['mconf-stats']['logstash']['plugins']       = []

# Logstash paths settings
default['mconf-stats']['logstash']['basedir']             = '/opt/logstash'
default['mconf-stats']['logstash']['instance_name']       = 'mconf'
default['mconf-stats']['logstash']['instance_home']       = "#{node['mconf-stats']['logstash']['basedir']}/#{node['mconf-stats']['logstash']['instance_name']}"
default['mconf-stats']['logstash']['instance_bin']        = "#{node['mconf-stats']['logstash']['instance_home']}/bin"
default['mconf-stats']['logstash']['instance_conf']       = "#{node['mconf-stats']['logstash']['instance_home']}/etc/conf.d"
default['mconf-stats']['logstash']['instance_config']     = "#{node['mconf-stats']['logstash']['instance_home']}/config"
default['mconf-stats']['logstash']['instance_data']       = "#{node['mconf-stats']['logstash']['instance_home']}/data"
default['mconf-stats']['logstash']['instance_log']        = "#{node['mconf-stats']['logstash']['instance_home']}/logs"
default['mconf-stats']['logstash']['instance_template']   = "#{node['mconf-stats']['logstash']['instance_home']}/templates"

# Logstash installation settings
default['mconf-stats']['logstash']['install_type']        = 'tarball'
default['mconf-stats']['logstash']['version']             = '5.1.2'
default['mconf-stats']['logstash']['source_url']          = "https://artifacts.elastic.co/downloads/logstash/logstash-#{node['mconf-stats']['logstash']['version']}.tar.gz"
default['mconf-stats']['logstash']['checksum']            = node['mconf-stats']['logstash']["#{node['mconf-stats']['logstash']['version']}"]['checksum']

# Logstash migration settings
default['mconf-stats']['logstash']['migration_dir']     = "#{node['mconf-stats']['logstash']['instance_home']}/etc/migration"
default['mconf-stats']['logstash']['migration_configs'] = nil

# Logstash mconf-stats cookbook settings
default['mconf-stats']['logstash']['user_configs']   = nil # Directories from this cookbooks where user's config/template files for logstash are.
default['mconf-stats']['logstash']['user_templates'] = nil # All files in these directories will be automatically copied to logstash.

# Logstash Elasticsearch settings
default['mconf-stats']['logstash']['es']['server']             = '127.0.0.1'
default['mconf-stats']['logstash']['es']['port']               = '9200'
default['mconf-stats']['logstash']['es']['index']              = 'logstash-%{+YYYY.MM.dd}'
default['mconf-stats']['logstash']['es']['index_alias']        = nil

# Logstash Elasticsearch index template settings
default['mconf-stats']['logstash']['es']['index_template']['template_name']      = 'index-template'
default['mconf-stats']['logstash']['es']['index_template']['index_pattern']      = 'logstash-*'
default['mconf-stats']['logstash']['es']['index_template']['number_of_shards']   = 1
default['mconf-stats']['logstash']['es']['index_template']['number_of_replicas'] = 0
default['mconf-stats']['logstash']['es']['index_template']['template_overwrite'] = false

# Logstash Lumberjack settings
default['mconf-stats']['logstash']['inputs']['lumberjack']                     = {}
default['mconf-stats']['logstash']['inputs']['lumberjack']['name']             = nil
default['mconf-stats']['logstash']['inputs']['lumberjack']['host']             = '0.0.0.0'
default['mconf-stats']['logstash']['inputs']['lumberjack']['port']             = 5960
default['mconf-stats']['logstash']['inputs']['lumberjack']['data_bag']         = 'lumberjack'
default['mconf-stats']['logstash']['inputs']['lumberjack']['data_item']        = 'secrets'
default['mconf-stats']['logstash']['inputs']['lumberjack']['certificate_path'] = "#{node['mconf-stats']['logstash']['instance_home']}/certs"
default['mconf-stats']['logstash']['inputs']['lumberjack']['ssl_ca']           = ['CA.crt']
default['mconf-stats']['logstash']['inputs']['lumberjack']['ssl_certificate']  = 'lumberjack.crt'
default['mconf-stats']['logstash']['inputs']['lumberjack']['ssl_key']          = 'lumberjack.key'

# Elasticsearch

# Elasticsearch general and installation settings
default['mconf-stats']['elasticsearch']['version']                   = "5.1.2"
default['mconf-stats']['elasticsearch']['install_type']              = "package"
default['mconf-stats']['elasticsearch']['cluster']['name']           = "mconf-cluster"
default['mconf-stats']['elasticsearch']['node']['master']            = true
default['mconf-stats']['elasticsearch']['node']['master_host']       = nil
default['mconf-stats']['elasticsearch']['allocated_memory']          = "256m"
default['mconf-stats']['elasticsearch']['network']['host']           = '0.0.0.0'
default['mconf-stats']['elasticsearch']['http']['port']              = 9200
default['mconf-stats']['elasticsearch']['user']                      = 'elasticsearch'
default['mconf-stats']['elasticsearch']['user_uid']                  = 998
default['mconf-stats']['elasticsearch']['group']                     = 'elasticsearch'
default['mconf-stats']['elasticsearch']['group_gid']                 = 998
default['mconf-stats']['elasticsearch']['disk_threshold']['enabled'] = true
default['mconf-stats']['elasticsearch']['disk_threshold']['low']     = '85%'
default['mconf-stats']['elasticsearch']['disk_threshold']['high']    = '90%'
default['mconf-stats']['elasticsearch']['backup_repo']               = ['/opt/elasticsearch/snapshots']

# Kibana

# Kibana general settings
default['mconf-stats']['kibana']['user']           = 'kibana'
default['mconf-stats']['kibana']['group']          = 'kibana'
default['mconf-stats']['kibana']['port']           = 5601
default['mconf-stats']['kibana']['http_port']      = 80
default['mconf-stats']['kibana']['bind_interface'] = node['ipaddress']

# Kibana paths settings
default['mconf-stats']['kibana']['basedir']   = '/opt'

# Kibana installation settings
default['mconf-stats']['kibana']['version']   = '5.1.2'
default['mconf-stats']['kibana']['checksum']  = node['mconf-stats']['kibana']["#{node['mconf-stats']['kibana']['version']}"]['checksum']

# Kibana mconf-stats cookbook settings
default['mconf-stats']['kibana']['objects_template'] = nil # Traditionally 'objects'

# Kibana Elasticsearch settings
default['mconf-stats']['kibana']['es']['server']        = '127.0.0.1'
default['mconf-stats']['kibana']['es']['index']         = node['mconf-stats']['logstash']['es']['index_template']['index_pattern']
default['mconf-stats']['kibana']['es']['kibana_index']  = '.kibana'

# Elasticdump

# Elasticdump installation settings
default['mconf-stats']['elasticdump']['version'] = '3.0.2'
