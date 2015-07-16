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

include_recipe 'elasticsearch'
# include_recipe 'elasticsearch::proxy'

es_url = "localhost:#{node['mconf-stats']['elasticsearch']['http']['port']}"

# Default configurations for elasticsearch
bash "elasticsearch default configs: disk threshold" do
  code <<-EOS
    curl -XPUT #{es_url}/_cluster/settings -d '{
      "transient" : {
        "cluster.routing.allocation.disk.threshold_enabled": "#{node['mconf-stats']['elasticsearch']['disk_threshold']['enabled']}",
        "cluster.routing.allocation.disk.watermark.low": "#{node['mconf-stats']['elasticsearch']['disk_threshold']['low']}",
        "cluster.routing.allocation.disk.watermark.high": "#{node['mconf-stats']['elasticsearch']['disk_threshold']['high']}"
      }
    }'
  EOS
  action :run
end
