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

elasticsearch_user 'elasticsearch' do
  username node['mconf-stats']['elasticsearch']['user']
  uid node['mconf-stats']['elasticsearch']['user_uid']
  groupname node['mconf-stats']['elasticsearch']['group']
  gid node['mconf-stats']['elasticsearch']['group_gid']
end

# Creates the directory used for store the snapshots in all nodes.
backup_dir = node['mconf-stats']['elasticsearch']['backup_repo'][0]

directory backup_dir do
  owner node['mconf-stats']['elasticsearch']['user']
  group node['mconf-stats']['elasticsearch']['group']
  mode '0755'
  action :create
  not_if { node['mconf-stats']['elasticsearch']['backup_repo'].nil? }
end

elasticsearch_install 'elasticsearch' do
  package_options "--force-confnew"
end

#
# Elasticsearch cookbook, for some reason, stopped upgrade the elasticsearch
# instance already installed, for this reason the following method was inserted
# to ensure the upgrade of the instance.
#
dpkg_package 'elasticsearch' do
  action :install
  options "--force-confnew"
  source "/var/chef/cache/elasticsearch-#{version node['mconf-stats']['elasticsearch']['version']}.deb"
  version version node['mconf-stats']['elasticsearch']['version']
end

#
# Restarting the instance to ensure that the new version is initialized
# before the configuration.
#
service 'elasticsearch' do
  action :restart
end

es_url = "http://localhost:#{node['mconf-stats']['elasticsearch']['http']['port']}"

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

elasticsearch_configure 'elasticsearch' do
    allocated_memory node['mconf-stats']['elasticsearch']['allocated_memory']
    configuration ({
      'path.repo' => node['mconf-stats']['elasticsearch']['backup_repo'],
      'cluster.name' => node['mconf-stats']['elasticsearch']['cluster']['name'],
      'http.port' => node['mconf-stats']['elasticsearch']['http']['port'],
      'discovery.zen.ping.multicast.enabled' => 'false',
      'network.host' => node['mconf-stats']['elasticsearch']['network']['host']
    })
end
elasticsearch_service 'elasticsearch'

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

service 'elasticsearch' do
  action :restart
end
