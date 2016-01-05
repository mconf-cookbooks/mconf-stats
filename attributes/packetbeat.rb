default['mconf-stats']['beats']['packetbeat']['version']      = '1.0.0'
default['mconf-stats']['beats']['packetbeat']['conf_dir']     = '/etc/packetbeat'
default['mconf-stats']['beats']['packetbeat']['conf_file']    = ::File.join(node['mconf-stats']['beats']['packetbeat']['conf_dir'], 'packetbeat.yml')
default['mconf-stats']['beats']['packetbeat']['service_name'] = 'packetbeat'
default['mconf-stats']['beats']['packetbeat']['config_path']  = '/etc/packetbeat/packetbeat.yml'
default['mconf-stats']['beats']['packetbeat']['shipper']      = nil
