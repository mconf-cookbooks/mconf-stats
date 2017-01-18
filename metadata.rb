#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

name             "mconf-stats"
maintainer       "mconf"
maintainer_email "mconf@mconf.org"
license          "MPL v2.0"
description      "Sets up an instance of Mconf-Stats"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
depends          'logstash', '~> 0.12.0'
depends          'elasticsearch', '~> 3.0.2'
depends          'logstash-forwarder', '0.2.0'
depends          'kibana_lwrp', '~> 3.0.2'
depends          'libarchive', '~> 0.4.0' # for kibana_lwrp with chef 11
depends          'hostsfile', '~> 2.4.5'
depends          'nodejs', '~> 2.4.0'
depends          'apt', '>= 2.7.0'
depends          'compat_resource', '= 12.5.10'

recipe "mconf-stats::default", "Sets up an instance of Mconf-Stats"
