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

# To prevent an error in the elasticsearch cookbook
override['elasticsearch']['nginx']['ssl'] = {}
