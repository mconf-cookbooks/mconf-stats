#
# Cookbook Name:: mconf-stats
# Recipe:: _common
# Author:: Kazuki Yokoyama (<yokoyama.km@gmail.com>)
#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

# Install all necessary packages
%W{git curl #{node['mconf-stats']['java_pkg']}}.each do |pkg|
  package pkg
end
