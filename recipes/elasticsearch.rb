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

es_url = "http://localhost:#{node['mconf-stats']['elasticsearch']['http']['port']}"

# Ensure elasticsearch is running, we need it now (kibana also needs it)
service 'elasticsearch' do
  action :start
end
ruby_block "wait elasticsearch to start" do
  block do
    1.upto(30) do |i|
      if system("curl -s '#{es_url}'")
        Chef::Log.info("Service elasticsearch started, will stop waiting! (loop #{i})")
        break
      end
      sleep 1
    end
  end
  action :run
end

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
