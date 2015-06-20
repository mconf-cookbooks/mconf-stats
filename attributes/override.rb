#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

override['elkstack']['config']['logstash']['instance_name'] = node['mconf-stats']['logstash']['instance_name']
override['elkstack']['config']['backups']['enabled']        = node['mconf-stats']['backups']['enabled']
override['elkstack']['config']['backups']['cron']           = node['mconf-stats']['backups']['cron']
override['elkstack']['config']['site_name']                 = node['mconf-stats']['site_name']
override['elkstack']['config']['kibana']['redirect']        = node['mconf-stats']['kibana']['redirect']

override['elkstack']['config']['custom_logstash'] = {}
override['elkstack']['config']['custom_logstash']['name'] = []

# Logstash
logstash_instance = node['elkstack']['config']['logstash']['instance_name']
override['logstash']['instance'][logstash_instance]['debug']         = node['mconf-stats']['logstash']['debug']
override['logstash']['instance'][logstash_instance]['install_type']  = node['mconf-stats']['logstash']['install_type']
override['logstash']['instance'][logstash_instance]['version']       = node['mconf-stats']['logstash']['version']
override['logstash']['instance'][logstash_instance]['source_url']    = node['mconf-stats']['logstash']['source_url']
override['logstash']['instance'][logstash_instance]['checksum']      = node['mconf-stats']['logstash']['checksum']
override['logstash']['instance'][logstash_instance]['xms']           = node['mconf-stats']['logstash']['xms']
override['logstash']['instance'][logstash_instance]['xmx']           = node['mconf-stats']['logstash']['xmx']

# override['elasticsearch']['allocated_memory'] = node['mconf-stats']['elasticsearch']['allocated_memory']
# override['elasticsearch']['version'] = node['mconf-stats']['elasticsearch']['version']

# elastic_dir = "elasticsearch-#{node['elasticsearch']['version']}"
# override['elasticsearch']['dir']          = '/opt'
# override['elasticsearch']['bindir']       = "/opt/#{elastic_dir}/bin"
# override['elasticsearch']['path']['conf'] = "/opt/#{elastic_dir}/etc"
# override['elasticsearch']['path']['data'] = "/opt/#{elastic_dir}/var/data"
# override['elasticsearch']['path']['logs'] = "/opt/#{elastic_dir}/var/logs"
# override['elasticsearch']['pid_path']     = "/opt/#{elastic_dir}/var/run"
# override['elasticsearch']['host']         = "https://download.elastic.co"

# # To prevent an error in the elasticsearch cookbook
# override['elasticsearch']['nginx']['ssl'] = {}
