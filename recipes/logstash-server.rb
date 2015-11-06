#
# Cookbook Name:: mconf-stats
# Recipe:: default
# Author:: Fernando de Avila Bottin (<fbottin@mconf.org>)
#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

node.run_state['lumberjack_for'] = :logstash_server

include_recipe 'mconf-stats::logstash'
