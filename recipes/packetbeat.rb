#
# Cookbook Name:: mconf-stats
# Recipe:: packetbeat
# Author:: Fernando de Avila Bottin (<fbottin@mconf.org>)
#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

include_recipe "mconf-stats::_beats_certificates"

include_recipe "mconf-stats::_install_beats_packages"

package 'packetbeat' do
  version node['mconf-stats']['beats']['packetbeat']['version']
end

certificate_path = "#{node['mconf-stats']['beats']['certificate_path']}/#{node['mconf-stats']['beats']['ssl_certificate']}"
certificate_key = "#{node['mconf-stats']['beats']['certificate_path']}/#{node['mconf-stats']['beats']['ssl_key']}"

template node['mconf-stats']['beats']['packetbeat']['config_path'] do
  source "/beats/packetbeat.erb"
  variables(
    redis_port: node['mconf-stats']['beats']['redis_port'],
    hosts: node['mconf-stats']['beats']['logstash_host'],
    shipper: node['mconf-stats']['beats']['packetbeat']['shipper'],
    ca_authorities: certificate_path,
    certificate: certificate_path,
    certificate_key: certificate_key
  )
end

service 'packetbeat' do
  supports :status => true, :restart => true
  action [:start, :enable]
end