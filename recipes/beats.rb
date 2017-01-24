#
# Cookbook Name:: mconf-stats
# Recipe:: beats
# Author:: Fernando de Avila Bottin (<fbottin@mconf.org>)
#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

# Default Beats recipe installs Filebeat, Packetbeat and Topbeat
include_recipe 'mconf-stats::packetbeat' if node['mconf-stats']['beats']['install_packetbeat']
include_recipe 'mconf-stats::filebeat' if node['mconf-stats']['beats']['install_filebeat']
include_recipe 'mconf-stats::topbeat' if node['mconf-stats']['beats']['install_topbeat']
