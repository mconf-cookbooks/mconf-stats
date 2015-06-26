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

# for when installing logstash server with a lumberjack input
path = node['mconf-stats']['logstash']['inputs']['lumberjack']['certificate_path']
certificate_source = node['mconf-stats']['logstash']['inputs']['lumberjack']['ssl_certificate']
certificate_path = "#{path}/#{certificate_source}"
key_source = node['mconf-stats']['logstash']['inputs']['lumberjack']['ssl_key']
key_path = "#{path}/#{key_source}"

bag_name = node['mconf-stats']['logstash']['inputs']['lumberjack']['data_bag']
bag_item = node['mconf-stats']['logstash']['inputs']['lumberjack']['data_item']

directory path do
  owner node['mconf-stats']['logstash']['user']
  group node['mconf-stats']['logstash']['group']
  mode '0755'
  recursive true
  action :create
end


# Read the certificates from a data bag and save to files
# Note: adapted code from https://github.com/rackspace-cookbooks/elkstack/blob/master/recipes/_lumberjack_secrets.rb

begin
  lumberjack_secrets = Chef::DataBagItem.load(bag_name, bag_item)
  lumberjack_secrets.to_hash
rescue
  Chef::Log.warn("Could not find un-encrypted data bag item #{bag_name}/#{bag_item}")
  lumberjack_secrets = nil
end

if !lumberjack_secrets.nil? && lumberjack_secrets['key'] && lumberjack_secrets['certificate']
  node.run_state['lumberjack_decoded_key'] = Base64.decode64(lumberjack_secrets['key'])
  node.run_state['lumberjack_decoded_certificate'] = Base64.decode64(lumberjack_secrets['certificate'])
elsif !lumberjack_secrets.nil?
  Chef::Log.warn('Found a data bag for lumberjack secrets, but it was missing \'key\' and \'certificate\' data bag items')
elsif lumberjack_secrets.nil?
  Chef::Log.warn('Could not find an encrypted or unencrypted data bag to use as a lumberjack keypair')
else
  Chef::Log.warn('Unable to complete lumberjack keypair configuration')
end

file key_path do
  content node.run_state['lumberjack_decoded_key']
  owner node['mconf-stats']['logstash']['user']
  group node['mconf-stats']['logstash']['group']
  mode '0600'
  not_if { node.run_state['lumberjack_decoded_key'].nil? }
end

file certificate_path do
  content node.run_state['lumberjack_decoded_certificate']
  owner node['mconf-stats']['logstash']['user']
  group node['mconf-stats']['logstash']['group']
  mode '0600'
  not_if { node.run_state['lumberjack_decoded_certificate'].nil? }
end
