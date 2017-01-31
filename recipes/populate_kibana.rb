#
# Cookbook Name:: mconf-stats
# Recipe:: populate_kibana
# Author:: Kazuki Yokoyama (<yokoyama.km@gmail.com>)
#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

# Accept data_bags to populate Kibana
bag_name = node['mconf-stats']['kibana']['data_bag']
begin
  kibana_bag = Chef::DataBag.load(bag_name)
  require 'json'
rescue
  kibana_bag = []
  Chef::Log.warn("Could not find unencrypted data bag #{bag_name}")
end

# Populate Kibana index in Elasticsearch using Elasticdump
kibana_bag.each_pair do |name, url|
  items = Chef::DataBagItem.load(bag_name, name)
  # so we get only the data we need, not all object
  items = items.to_hash

  input_file = ::File.join(Chef::Config[:file_cache_path], "kibana-seed-#{name}.json")
  file input_file do
    content items.to_json.to_s
  end

  bash "load kibana item #{name}" do
    code Elasticdump.import_cmd(input_file,
                                es_server,
                                node['mconf-stats']['kibana']['es_index'])
    action :run
  end
end
