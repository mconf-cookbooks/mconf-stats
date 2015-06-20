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

%W{git #{node['mconf-stats']['java_pkg']}}.each do |pkg|
  package pkg
end

# Map the config files set in this cookbook to the ones expected by elkstack
node['mconf-stats']['logstash']['inputs'].each do |config|
  node.override['elkstack']['config']['custom_logstash']['name'] += ["input-#{config['name']}"]
  base = node.override['elkstack']['config']['custom_logstash']["input-#{config['name']}"]
  base['name'] = config['name']
  base['source'] = 'logstash/input_file.conf.erb'
  base['cookbook'] = 'mconf-stats'
  base['variables'] = config
end
node['mconf-stats']['logstash']['outputs']['elasticsearch'].each do |config|
  node.override['elkstack']['config']['custom_logstash']['name'] += ["output-es-#{config['name']}"]
  base = node.override['elkstack']['config']['custom_logstash']["output-es-#{config['name']}"]
  base['name'] = config['name']
  base['source'] = 'logstash/output_elasticsearch.conf.erb'
  base['cookbook'] = 'mconf-stats'
  base['variables'] = config
end

include_recipe 'elkstack::logstash'

# Remove old configs we didn't create, including a few defaults created by elkstack
ruby_block 'remove unused logstash configs' do
  block do
    configs_created = node['elkstack']['config']['custom_logstash']['name'].map{ |c|
      "#{node['mconf-stats']['logstash']['confdir']}/#{node['elkstack']['config']['custom_logstash'][c]['name']}"
    }
    Dir["#{node['mconf-stats']['logstash']['confdir']}/*"].each do |path|
      unless configs_created.include?(path)
        r = Chef::Resource::File.new(path, run_context)
        r.path       path
        r.run_action :delete
      end
    end
  end
  action :run
end
