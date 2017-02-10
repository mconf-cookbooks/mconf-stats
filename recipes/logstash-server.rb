#
# Cookbook Name:: mconf-stats
# Recipe:: logstash-server
# Author:: Fernando de Avila Bottin (<fbottin@mconf.org>)
#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

# Install necessary packages (such as Java)
include_recipe 'mconf-stats::_common'

node.run_state['lumberjack_for'] = :logstash_server

# Install Logstash
include_recipe 'mconf-stats::logstash'

# Install 'xml-simple' gem needed in Logstash filters
gem_package 'xml-simple'

# Add logstash user to syslog complementary group
execute "usermod -a -G syslog logstash"
