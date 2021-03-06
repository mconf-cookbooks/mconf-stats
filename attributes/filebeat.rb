# Filebeat

# Filebeat specific settings
default['mconf-stats']['beats']['filebeat']['version']            = '5.1.2'
default['mconf-stats']['beats']['filebeat']['conf_dir']           = '/etc/filebeat'
default['mconf-stats']['beats']['filebeat']['conf_file']          = ::File.join(node['mconf-stats']['beats']['filebeat']['conf_dir'], 'filebeat.yml')
default['mconf-stats']['beats']['filebeat']['service_name']       = 'filebeat'
default['mconf-stats']['beats']['filebeat']['config_path']        = '/etc/filebeat/filebeat.yml'
default['mconf-stats']['beats']['filebeat']['prospectors']        = nil
default['mconf-stats']['beats']['filebeat']['shipper']            = nil
default['mconf-stats']['beats']['filebeat']['ignore_older']       = "24h"
default['mconf-stats']['beats']['filebeat']['input_type']         = "log"
