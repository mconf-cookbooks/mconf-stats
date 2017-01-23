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
if node.run_state['lumberjack_for'] == :forwarder
  path = node['mconf-stats']['logstash-forwarder']['certificate_path']
  certificate_filename = node['mconf-stats']['logstash-forwarder']['ssl_certificate']
  key_filename = nil # key is not necessary for the forwarder
  bag_name = node['mconf-stats']['logstash-forwarder']['data_bag']
  bag_item = node['mconf-stats']['logstash-forwarder']['data_item']
  target_user = 'root'
  target_group = 'root'
elsif node.run_state['lumberjack_for'] == :logstash_client
  path = node['mconf-stats']['logstash']['inputs']['lumberjack']['certificate_path']
  certificate_filename = node['mconf-stats']['logstash']['inputs']['lumberjack']['ssl_certificate']
  bag_name = node['mconf-stats']['logstash']['inputs']['lumberjack']['data_bag']
  bag_item = node['mconf-stats']['logstash']['inputs']['lumberjack']['data_item']
  target_user = node['mconf-stats']['logstash']['user']
  target_group = node['mconf-stats']['logstash']['group']
else
  path = node['mconf-stats']['logstash']['inputs']['lumberjack']['certificate_path']
  certificate_filename = node['mconf-stats']['logstash']['inputs']['lumberjack']['ssl_certificate']
  key_filename = node['mconf-stats']['logstash']['inputs']['lumberjack']['ssl_key']
  ca_filenames = node['mconf-stats']['logstash']['inputs']['lumberjack']['ssl_ca']
  bag_name = node['mconf-stats']['logstash']['inputs']['lumberjack']['data_bag']
  bag_item = node['mconf-stats']['logstash']['inputs']['lumberjack']['data_item']
  target_user = node['mconf-stats']['logstash']['user']
  target_group = node['mconf-stats']['logstash']['group']
end
certificate_path = "#{path}/#{certificate_filename}"
key_path = key_filename ? "#{path}/#{key_filename}" : nil
ca_path = ca_filenames.map { |ca| "#{path}/#{ca}" }

node.run_state['certificate_path'] = certificate_path
node.run_state['key_path'] = key_path
node.run_state['ca_path'] = ca_path


directory path do
  owner target_user
  group target_group
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

if !lumberjack_secrets.nil?
  if lumberjack_secrets['key']
    node.run_state['lumberjack_decoded_key'] = Base64.decode64(lumberjack_secrets['key'])
  else
    Chef::Log.warn('Found a data bag for lumberjack secrets, but it was missing the \'key\' item')
  end
  if lumberjack_secrets['certificate']
    node.run_state['lumberjack_decoded_certificate'] = Base64.decode64(lumberjack_secrets['certificate'])
  else
    Chef::Log.warn('Found a data bag for lumberjack secrets, but it was missing the \'certificate\' item')
  end
  if lumberjack_secrets['ca'] and not lumberjack_secrets['ca'].empty?
    node.run_state['lumberjack_decoded_ca'] = []
    lumberjack_secrets['ca'].each { |ca| node.run_state['lumberjack_decoded_ca'] << Base64.decode64(ca) }
  else
    Chef::Log.warn('Found a data bag for lumberjack secrets, but it was missing the \'CA certificate\' item')
  end
else
  Chef::Log.warn('Could not find an encrypted or unencrypted data bag to use as a lumberjack keypair')
end

unless key_path.nil?
  file key_path do
    content node.run_state['lumberjack_decoded_key']
    owner target_user
    group target_group
    mode '0600'
    not_if { node.run_state['lumberjack_decoded_key'].nil? }
    notifies :restart, "service[#{node.run_state['logstash_service']}]", :delayed
  end
end

file certificate_path do
  content node.run_state['lumberjack_decoded_certificate']
  owner target_user
  group target_group
  mode '0600'
  not_if { node.run_state['lumberjack_decoded_certificate'].nil? }
  notifies :restart, "service[#{node.run_state['logstash_service']}]", :delayed
end

ca_path.zip(node.run_state['lumberjack_decoded_ca']).each do |ca_file, ca_decoded|
  file ca_file do
    content ca_decoded
    owner target_user
    group target_group
    mode '0600'
    not_if { node.run_state['lumberjack_decoded_ca'].nil? }
    notifies :restart, "service[#{node.run_state['logstash_service']}]", :delayed
  end
end
