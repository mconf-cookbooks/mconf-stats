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

node.run_state['lumberjack_for'] = :forwarder
node.run_state['logstash_service'] = node['mconf-stats']['logstash-forwarder']['service_name']
include_recipe "mconf-stats::_lumberjack_certificates"

include_recipe 'logstash-forwarder'

node['mconf-stats']['logstash-forwarder']['logs'].each do |log|
  log_forward log['name'] do
    paths log['paths']
    fields log['fields']
  end
end

# Mappings in case servers are referenced by IP.
node['mconf-stats']['logstash-forwarder']['logstash_servers_mappings'].each_pair do |ip, domain|
  hostsfile_entry ip do
    hostname  domain
    unique    true
  end
end
