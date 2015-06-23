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

chef_gem "chef-rewind"
require 'chef/rewind'

include_recipe "elkstack::forwarder"

# Rewinding is the only way to disable the default files configured by elkstack
# TODO: Could simply node.rm('logstash_forwarder', 'config', 'files') in Chef 12, but not
#   available on 11. See https://github.com/chef/chef-rfc/blob/master/rfc023-chef-12-attributes-changes.md
config = {}
config['network'] = {
  'servers' => node['mconf-stats']['forwarder']['network']['servers'],
  'ssl certificate' => node['mconf-stats']['forwarder']['network']['ssl_certificate'],
  'ssl key' => node['mconf-stats']['forwarder']['network']['ssl_key'],
  'ssl ca' => node['mconf-stats']['forwarder']['network']['ssl_ca'],
  'timeout' => node['mconf-stats']['forwarder']['network']['timeout']
}
config['files'] = []

# Add the files configured by the user
node['mconf-stats']['forwarder']['files'].each do |file_config|
  config['files'] << file_config
end

require 'json'
rewind "file[#{node['logstash_forwarder']['config_file']}]" do
  content JSON.pretty_generate(config)
end
