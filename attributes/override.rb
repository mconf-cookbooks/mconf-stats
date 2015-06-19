#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

override['logstash']['instance']['mconf-stats']['debug'] = node['mconf-stats']['logstash']['debug']



# override['logstash']['instance_default']['debug'] = node['mconf-stats']['logstash']['debug']
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
