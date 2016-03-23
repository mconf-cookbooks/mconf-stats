#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

# Notes about the applications installed:
#
# * Logstash
#   path: /opt
#   log: /opt/logstash/mconf/log/logstash.log
#   init: /etc/sv/logstash_mconf/run
#   default port for lumberjack: 5960
#
# * ElasticSearch
#   path: /usr/local/
#   logs: /usr/local/var/log/elasticsearch
#   config: /usr/local/etc/elasticsearch/elasticsearch.yml
#   init: /etc/init.d/elasticsearch
#   default http port: 9200
#   default node ports: 9300-9400 (gets the first one that's free)
#
# * Kibana
#   path: /opt/kibana/current
#   logs: /opt/kibana/current/log/kibana.log
#   config: /opt/kibana/current/config/kibana.yml
#   init: /etc/init/kibana
#   default port: 5601, 80

# User and group on the server the application is being deployed
default['mconf-stats']['user']      = 'mconf'
default['mconf-stats']['app_group'] = 'www-data'
default['mconf-stats']['domain']    = '192.168.0.100'
default['mconf-stats']['java_pkg']  = 'openjdk-7-jre-headless'

# Logstash
default['mconf-stats']['logstash']['user']          = 'logstash'
default['mconf-stats']['logstash']['group']         = 'logstash'
default['mconf-stats']['logstash']['basedir']       = '/opt/logstash'
default['mconf-stats']['logstash']['instance_name'] = 'mconf'
default['mconf-stats']['logstash']['instance_home'] = "#{node['mconf-stats']['logstash']['basedir']}/#{node['mconf-stats']['logstash']['instance_name']}"
default['mconf-stats']['logstash']['instance_conf'] = "#{node['mconf-stats']['logstash']['instance_home']}/etc/conf.d"
default['mconf-stats']['logstash']['debug']         = false
default['mconf-stats']['logstash']['install_type']  = 'tarball'
default['mconf-stats']['logstash']['version']       = '2.2.2'
default['mconf-stats']['logstash']['source_url']    = "https://download.elasticsearch.org/logstash/logstash/logstash-#{node['mconf-stats']['logstash']['version']}.tar.gz"
default['mconf-stats']['logstash']['checksum']      = 'f0a29ec8fd327e42f3023bd6bf85a00ac20617bfc214df59c765453977398312'  #logstash-2.2.2.tar.gz

default['mconf-stats']['logstash']['xms']           = '1536M'
default['mconf-stats']['logstash']['xmx']           = '1536M'
default['mconf-stats']['logstash']['log_file']      = 'logstash.log'
default['mconf-stats']['logstash']['plugins']       = nil

default['mconf-stats']['logstash']['migration_dir'] = "#{node['mconf-stats']['logstash']['instance_home']}/etc/migration"
default['mconf-stats']['logstash']['migration_configs'] = nil

# Directory from this cookbooks where user's config files for logstash are.
# All files in this directory will be automatically copied to logstash.
default['mconf-stats']['logstash']['user_configs'] = nil

# Example:
# [
#   {
#     "name": "0-input-main.conf",
#     "path": "/my/file/1.log",
#     "type": "rails",
#     "codec": "json"
#   }
# ]
default['mconf-stats']['logstash']['inputs']['files'] = []

# Example:
# [
#   {
#     "name": "9-output-elasticsearch.conf",
#     "host": "localhost",
#     "cluster": "mconf_cluster",
#     "embedded": false,
#     "bind_host": null,
#     "es_index": null
#   }
# ]
default['mconf-stats']['logstash']['outputs']['elasticsearch'] = []

# Example:
# {
#   "name": "9-output-stdout.conf",
#   "codec": "rubydebug"
# }
default['mconf-stats']['logstash']['outputs']['stdout'] = {}

# Lumberjack input
# Certificates are taken from the data bag and saved to disk in the paths specified below
default['mconf-stats']['logstash']['inputs']['lumberjack']                     = {}
default['mconf-stats']['logstash']['inputs']['lumberjack']['name']             = nil
default['mconf-stats']['logstash']['inputs']['lumberjack']['host']             = '0.0.0.0'
default['mconf-stats']['logstash']['inputs']['lumberjack']['port']             = 5960
default['mconf-stats']['logstash']['inputs']['lumberjack']['data_bag']         = 'lumberjack'
default['mconf-stats']['logstash']['inputs']['lumberjack']['data_item']        = 'secrets'
default['mconf-stats']['logstash']['inputs']['lumberjack']['certificate_path'] = "#{default['mconf-stats']['logstash']['instance_home']}/certs"
default['mconf-stats']['logstash']['inputs']['lumberjack']['ssl_certificate']  = 'lumberjack.crt'
default['mconf-stats']['logstash']['inputs']['lumberjack']['ssl_key']          = 'lumberjack.key'


# Elastic Search
default['mconf-stats']['elasticsearch']['version']                   = "2.2.0"
default['mconf-stats']['elasticsearch']['cluster']['name']           = "mconf_cluster"
default['mconf-stats']['elasticsearch']['node']['master']            = true
default['mconf-stats']['elasticsearch']['node']['master_host']       = nil
default['mconf-stats']['elasticsearch']['allocated_memory']          = "2048m"
default['mconf-stats']['elasticsearch']['network']['host']           = '0.0.0.0'
default['mconf-stats']['elasticsearch']['http']['port']              = 9200
default['mconf-stats']['elasticsearch']['user']                      = 'elasticsearch'
default['mconf-stats']['elasticsearch']['disk_threshold']['enabled'] = true
default['mconf-stats']['elasticsearch']['disk_threshold']['low']     = '85%'
default['mconf-stats']['elasticsearch']['disk_threshold']['high']    = '90%'
default['mconf-stats']['elasticsearch']['backup_repo']               = ['/opt/elasticsearch/snapshots']


# Kibana
default['mconf-stats']['kibana']['basedir']   = '/opt'
default['mconf-stats']['kibana']['version']   = '4.4.1'
default['mconf-stats']['kibana']['checksum']   = 'fb536696b27b9807507c5d9014c90722e7b28cb2e068a80879cc9bb861316be1'  #kibana-4.4.1-linux-x64.tar.gz

default['mconf-stats']['kibana']['user']      = 'kibana'
default['mconf-stats']['kibana']['group']     = 'kibana'
default['mconf-stats']['kibana']['port']      = 5601
default['mconf-stats']['kibana']['http_port'] = 80
default['mconf-stats']['kibana']['es_index']  = '.kibana'
default['mconf-stats']['kibana']['data_bag']  = 'kibana'

# Elasticdump
default['mconf-stats']['elasticdump']['version'] = '0.14.1'
