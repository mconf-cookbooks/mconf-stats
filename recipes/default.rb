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

%W{git curl #{node['mconf-stats']['java_pkg']}}.each do |pkg|
  package pkg
end

include_recipe 'mconf-stats::logstash'
include_recipe 'mconf-stats::elasticsearch'
include_recipe 'mconf-stats::elasticdump'
include_recipe 'mconf-stats::kibana'
