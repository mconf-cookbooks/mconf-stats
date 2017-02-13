#
# Cookbook Name:: mconf-stats
# Recipe:: _populate_kibana
# Author:: Kazuki Yokoyama (<yokoyama.km@gmail.com>)
#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

# Elasticsearch server and Kibana's configuration index
es_server = "#{node['kibana']['es_scheme']}#{node['kibana']['es_server']}:#{node['kibana']['es_port']}"
es_kibana_index = node['mconf-stats']['kibana']['es']['kibana_index']
objects_template = node['mconf-stats']['kibana']['objects_template']
objects_file = ::File.join(Chef::Config[:file_cache_path], "#{objects_template}.json")

# Create JSON file from template with all Kibana's objects (only if such template exists)
template objects_file do
  source "kibana/kibana_objects/#{objects_template}.json.erb"
  mode '0644'
  variables(
    index: node['mconf-stats']['kibana']['es']['index']
  )
  notifies :run, "ruby_block[load Kibana objects using Elasticdump]", :delayed
  not_if { objects_template.nil? }
end

# Populate Kibana index in Elasticsearch using Elasticdump (only if template was installed)
ruby_block "load Kibana objects using Elasticdump" do
  block do
    Elasticdump.import_objects(objects_file, es_server, es_kibana_index)
  end
  action :nothing
  notifies :delete, "template[#{objects_file}]", :delayed
end

# Delete template (only if template was installed)
template objects_file do
  action :nothing
end
