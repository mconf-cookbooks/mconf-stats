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

# Setup the secrets for logstash
# It will only setup if the data bags with the secrets exist, otherwise won't do anything
include_recipe "mconf-stats::_beats_certificates"

include_recipe "mconf-stats::_install_beats_packages"

package 'packetbeat' do
  options "-o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'"
  version node['mconf-stats']['beats']['packetbeat']['version']
end

certs_path = node['mconf-stats']['beats']['certificate_path']
certificate_path = "#{certs_path}/#{node['mconf-stats']['beats']['ssl_certificate']}"
key_path = "#{certs_path}/#{node['mconf-stats']['beats']['ssl_key']}"
ca = node['mconf-stats']['beats']['ssl_ca']
ca_path = ca.map { |ca| "#{certs_path}/#{ca}" }

# Create the configuration file with the informations received
template node['mconf-stats']['beats']['packetbeat']['config_path'] do
  source "/beats/packetbeat.erb"
  variables(
    redis_port: node['mconf-stats']['beats']['redis_port'],
    hosts: node['mconf-stats']['beats']['logstash_host'],
    shipper: node['mconf-stats']['beats']['packetbeat']['shipper'],
    ca_authorities: ca_path,
    certificate: certificate_path,
    certificate_key: key_path
  )
end

service 'packetbeat' do
  supports :status => true, :restart => true
  action [:start, :enable]
end

service 'packetbeat' do
  action :restart
end
