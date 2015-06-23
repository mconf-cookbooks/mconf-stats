#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

default['mconf-stats']['forwarder']['config_file'] = '/etc/logstash-forwarder'
default['mconf-stats']['forwarder']['files'] = []
default['mconf-stats']['forwarder']['network']['servers'] = [ "#{node['mconf-stats']['domain']}:9200" ]
default['mconf-stats']['forwarder']['network']['ssl_certificate'] = ''
default['mconf-stats']['forwarder']['network']['ssl_key'] = ''
default['mconf-stats']['forwarder']['network']['ssl_ca'] = ''
default['mconf-stats']['forwarder']['network']['timeout'] = 15
