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

# Install necessary packages (such as Java)
include_recipe 'mconf-stats::common'

# Create Elasticsearch user and group
elasticsearch_user 'elasticsearch' do
  username node['mconf-stats']['elasticsearch']['user']
  uid node['mconf-stats']['elasticsearch']['user_uid']
  groupname node['mconf-stats']['elasticsearch']['group']
  gid node['mconf-stats']['elasticsearch']['group_gid']
end

# Create the directory used for store the snapshots in all nodes.
backup_dir = node['mconf-stats']['elasticsearch']['backup_repo'][0]

# Create the directory to hold backup data
directory backup_dir do
  owner node['mconf-stats']['elasticsearch']['user']
  group node['mconf-stats']['elasticsearch']['group']
  mode '0755'
  recursive true
  action :create
  not_if { node['mconf-stats']['elasticsearch']['backup_repo'].nil? }
end

# Install Elasticsearch using cookbook-elasticsearch cookbook resource
elasticsearch_install 'elasticsearch' do
  type node['mconf-stats']['elasticsearch']['install_type']
  version node['mconf-stats']['elasticsearch']['version']
  package_options "--force-confnew"
end

# Restart Elasticsearch service before configuring it
service 'elasticsearch' do
  action :restart
end

# Wait up to 30 seconds until Elasticsearch starts
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

# Configure Elasticsearch using cookbook-elasticsearch cookbook resource
elasticsearch_configure 'elasticsearch' do
    allocated_memory node['mconf-stats']['elasticsearch']['allocated_memory']
    configuration ({
      'path.repo' => backup_dir,
      'cluster.name' => node['mconf-stats']['elasticsearch']['cluster']['name'],
      'http.port' => node['mconf-stats']['elasticsearch']['http']['port'],
      'network.host' => node['mconf-stats']['elasticsearch']['network']['host']
    })
end

# Create Elasticsearch service using cookbook-elasticsearch cookbook resource
elasticsearch_service 'elasticsearch'

# Start Elasticsearch service
service 'elasticsearch' do
  action :start
end

# Ensure Elasticsearch is running. We need it now (kibana also does).
# Wait up to 30 seconds until Elasticsearch starts
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

# Import default configurations for Elasticsearch using the _cluster API
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

# Always restart the service at the end of the recipe
service 'elasticsearch' do
  action :restart
end
