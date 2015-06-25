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
#   init: /etc/init.d/elasticsearch
#   default http port: 9200
#   default node port: 9300

# User and group on the server the application is being deployed
default['mconf-stats']['user'] = 'mconf'
default['mconf-stats']['app_group'] = 'www-data'
default['mconf-stats']['domain'] = '192.168.0.100'
default['mconf-stats']['java_pkg'] = 'openjdk-7-jre-headless'

# Logstash
default['mconf-stats']['logstash']['user']          = 'logstash'
default['mconf-stats']['logstash']['group']         = 'logstash'
default['mconf-stats']['logstash']['basedir']       = '/opt/logstash'
default['mconf-stats']['logstash']['instance_name'] = 'mconf'
default['mconf-stats']['logstash']['instance_home'] = "#{node['mconf-stats']['logstash']['basedir']}/#{node['mconf-stats']['logstash']['instance_name']}"
default['mconf-stats']['logstash']['instance_conf'] = "#{node['mconf-stats']['logstash']['instance_home']}/etc/conf.d"
default['mconf-stats']['logstash']['debug']         = false
default['mconf-stats']['logstash']['install_type']  = 'tarball'
default['mconf-stats']['logstash']['version']       = '1.5.1'
default['mconf-stats']['logstash']['source_url']    = 'https://download.elasticsearch.org/logstash/logstash/logstash-1.5.1.tar.gz'
default['mconf-stats']['logstash']['checksum']      = 'a12f91bc87f6cd8f1b481c9e9d0370a650b2c36fdc6a656785ef883cb1002894' # sha256sum logstash-1.5.1.tar.gz
default['mconf-stats']['logstash']['xms']           = '1536M'
default['mconf-stats']['logstash']['xmx']           = '1536M'
default['mconf-stats']['logstash']['log_file']      = 'logstash.log'

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
default['mconf-stats']['elasticsearch']['version']          = "1.6.0"
default['mconf-stats']['elasticsearch']['cluster']['name']  = "mconf_cluster"
default['mconf-stats']['elasticsearch']['allocated_memory'] = "2048m"
default['mconf-stats']['elasticsearch']['http']['port']     = 9200
default['mconf-stats']['elasticsearch']['user']             = 'elasticsearch'
