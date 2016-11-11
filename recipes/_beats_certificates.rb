#
# Cookbook Name:: mconf-stats
# Recipe:: _beats_certificates
# Author:: Fernando de Avila Bottin (<fbottin@mconf.org>)
#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

if node['mconf-stats']['beats']['install_certificates']

  path = node['mconf-stats']['beats']['certificate_path']
  certificate_filename = node['mconf-stats']['beats']['ssl_certificate']
  key_filename = node['mconf-stats']['beats']['ssl_key']
  ca_filenames = node['mconf-stats']['beats']['ssl_ca']
  bag_name = node['mconf-stats']['beats']['data_bag']
  bag_item = node['mconf-stats']['beats']['data_item']
  target_user = 'root'
  target_group = 'root'

  certificate_path = "#{path}/#{certificate_filename}"
  key_path = key_filename ? "#{path}/#{key_filename}" : nil
  ca_path = ca_filenames.map { |ca| "#{path}/#{ca}" }


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
    beats_secrets = Chef::DataBagItem.load(bag_name, bag_item)
    beats_secrets.to_hash
  rescue
    Chef::Log.warn("Could not find un-encrypted data bag item #{bag_name}/#{bag_item}")
    beats_secrets = nil
  end

  if !beats_secrets.nil?
    if beats_secrets['key']
      node.run_state['lumberjack_decoded_key'] = Base64.decode64(beats_secrets['key'])
    else
      Chef::Log.warn('Found a data bag for beats secrets, but it was missing the \'key\' item')
    end
    if beats_secrets['certificate']
      node.run_state['lumberjack_decoded_certificate'] = Base64.decode64(beats_secrets['certificate'])
    else
      Chef::Log.warn('Found a data bag for beats secrets, but it was missing the \'certificate\' item')
    end
    if beats_secrets['ca'] and not beats_secrets['ca'].empty?
      node.run_state['lumberjack_decoded_ca'] = []
      beats_secrets['ca'].each { |ca| node.run_state['lumberjack_decoded_ca'] << Base64.decode64(ca) }
    else
      Chef::Log.warn('Found a data bag for beats secrets, but it was missing the \'CA\' item')
    end
  else
    Chef::Log.warn('Could not find an encrypted or unencrypted data bag to use as a beats keypair')
  end

  unless key_path.nil?
    file key_path do
      content node.run_state['lumberjack_decoded_key']
      owner target_user
      group target_group
      mode '0600'
      not_if { node.run_state['lumberjack_decoded_key'].nil? }
    end
  end

  file certificate_path do
    content node.run_state['lumberjack_decoded_certificate']
    owner target_user
    group target_group
    mode '0600'
    not_if { node.run_state['lumberjack_decoded_certificate'].nil? }
  end

  ca_path.zip(node.run_state['lumberjack_decoded_ca']).each do |ca_file, ca_decoded|
    file ca_file do
      content ca_decoded
      owner target_user
      group target_group
      mode '0600'
      not_if { node.run_state['lumberjack_decoded_ca'].empty? }
    end
  end

  node.default['mconf-stats']['beats']['install_certificates'] = false
end
