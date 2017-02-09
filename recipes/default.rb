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

# Default recipe installs Logstash, Elasticsearch and Kibana
include_recipe 'mconf-stats::elasticsearch'
include_recipe 'mconf-stats::logstash-server'
include_recipe 'mconf-stats::kibana'
