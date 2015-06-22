#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

# Elkstack general configs
override['elkstack']['config']['logstash']['instance_name'] = node['mconf-stats']['logstash']['instance_name']
override['elkstack']['config']['backups']['enabled']        = node['mconf-stats']['backups']['enabled']
override['elkstack']['config']['backups']['cron']           = node['mconf-stats']['backups']['cron']
override['elkstack']['config']['site_name']                 = node['mconf-stats']['site_name']
override['elkstack']['config']['kibana']['redirect']        = node['mconf-stats']['kibana']['redirect']

override['elkstack']['config']['custom_logstash'] = {}
override['elkstack']['config']['custom_logstash']['name'] = []

# Temporarily disabled until properly configured
default['elkstack']['config']['cloud_monitoring']['enabled'] = false
default['elkstack']['config']['iptables']['enabled']         = false

# Logstash
logstash_instance = node['elkstack']['config']['logstash']['instance_name']
override['logstash']['instance'][logstash_instance]['debug']         = node['mconf-stats']['logstash']['debug']
override['logstash']['instance'][logstash_instance]['install_type']  = node['mconf-stats']['logstash']['install_type']
override['logstash']['instance'][logstash_instance]['version']       = node['mconf-stats']['logstash']['version']
override['logstash']['instance'][logstash_instance]['source_url']    = node['mconf-stats']['logstash']['source_url']
override['logstash']['instance'][logstash_instance]['checksum']      = node['mconf-stats']['logstash']['checksum']
override['logstash']['instance'][logstash_instance]['xms']           = node['mconf-stats']['logstash']['xms']
override['logstash']['instance'][logstash_instance]['xmx']           = node['mconf-stats']['logstash']['xmx']


# ElasticSearch
override['elasticsearch']['version']          = node['mconf-stats']['elasticsearch']['version']
override['elasticsearch']['allocated_memory'] = node['mconf-stats']['elasticsearch']['allocated_memory']
override['elasticsearch']['cluster']['name']  = node['mconf-stats']['elasticsearch']['cluster']['name']
override['elasticsearch']['plugins']          = {}
override['elasticsearch']['host']             = "https://download.elastic.co"
override['elasticsearch']['network']['host']  = node['mconf-stats']['domain']

# # To prevent an error in the elasticsearch cookbook
# override['elasticsearch']['nginx']['ssl'] = {}
