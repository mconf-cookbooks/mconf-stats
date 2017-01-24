#
# Cookbook Name:: mconf-stats
# Recipe:: _install_beats_packages
# Author:: Fernando de Avila Bottin (<fbottin@mconf.org>)
#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

# Add Beats official repository
apt_repository 'beats' do
  uri node['mconf-stats']['beats']['apt']['uri']
  components node['mconf-stats']['beats']['apt']['components']
  key node['mconf-stats']['beats']['apt']['key']
  action node['mconf-stats']['beats']['apt']['action']
end

package "apt-transport-https"

# Update package repositories list
execute 'apt-get-update' do
  command 'apt-get update'
  ignore_failure true
  not_if { ::File.exists?('/var/lib/apt/periodic/update-success-stamp') }
end
