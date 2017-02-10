#
# Cookbook Name:: mconf-stats
# Recipe:: elasticdump
# Author:: Leonardo Crauss Daronco (<daronco@mconf.org>)
#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

# Install necessary packages (such as Java)
include_recipe 'mconf-stats::_common'

# Install Node.js and npm via nodejs cookbook recipe
include_recipe 'nodejs'

# Install Elasticdump via nodejs cookbook resource
nodejs_npm 'elasticdump' do
  version node['mconf-stats']['elasticdump']['version']
end
