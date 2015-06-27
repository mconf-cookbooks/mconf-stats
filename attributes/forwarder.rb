#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

# Notes about the paths:
#
# * Logstash-forwarder
#   path: /opt/logstash-forwarder
#   config: /etc/logstash-forwarder.conf
#   logs: /var/log/logstash-forwarder
#   port usually used for lumberjack: 5960


# Logstash-forwarder
# Certificates are taken from the data bag and saved to disk in the paths specified below
default['mconf-stats']['logstash-forwarder']['service_name']     = 'logstash-forwarder'
default['mconf-stats']['logstash-forwarder']['timeout']          = 15
default['mconf-stats']['logstash-forwarder']['config_path']      = '/etc/logstash-forwarder.conf'
default['mconf-stats']['logstash-forwarder']['version']          = '0.4.0'
default['mconf-stats']['logstash-forwarder']['certificate_path'] = "/opt/logstash-forwarder/certs"
default['mconf-stats']['logstash-forwarder']['ssl_certificate']  = 'logstash-forwarder.crt'
default['mconf-stats']['logstash-forwarder']['data_bag']         = 'logstash-forwarder'
default['mconf-stats']['logstash-forwarder']['data_item']        = 'secrets'

# Example:
#   [ "elk.my.domain:5960" ]
# Important: Always use hostnames/domains instead of IPs! IPs require the certificates
#   to be generated in an specific way, not as easy as when using domains.
#   See https://github.com/elastic/logstash-forwarder#important-tlsssl-certificate-notes
#   If you must use an IP, see the attribute `logstash_servers_mappings`.
default['mconf-stats']['logstash-forwarder']['logstash_servers'] = []

# If you don't have a domain for the elk server, you can add entries to the the hosts file to
# map "fake" domains to your IP and then use these domains in logstash-forwarder.
# Example:
# {
#   "1.2.3.4": "elk.my.domain",
#   "2.3.4.5": "other.my.domain"
# }
default['mconf-stats']['logstash-forwarder']['logstash_servers_mappings'] = []

# Example:
# [
#   {
#     "name": "nginx",
#     "paths": ["/var/log/nginx/access.log", "/var/log/nginx/error.log"],
#     "fields": { "types": "nginx" }
#   }
# ]
default['mconf-stats']['logstash-forwarder']['logs'] = []
