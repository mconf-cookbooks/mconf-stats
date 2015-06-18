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

logstash_name = 'mconf'

# install logstash
logstash_instance logstash_name do
  create_account true
  action :create
end

# # services are hard! Let's go LWRP'ing.   FIREBALL! FIREBALL! FIREBALL!
# logstash_service name do
#   action      [:enable]
# end

# logstash_config name do
#   variables(
#             input_file_name: '/var/log/syslog',
#             input_file_type: 'syslog'
#             )
#   notifies :restart, "logstash_service[#{name}]"
#   action [:create]
# end

# logstash_pattern name do
#   action [:create]
# end
