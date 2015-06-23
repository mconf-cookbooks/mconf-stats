# TODO: setting the version doesn't do anything
default['logstash_forwarder']['version'] = '0.4.0'
default['logstash_forwarder']['config_file'] = '/etc/logstash-forwarder'
default['logstash_forwarder']['user'] = 'root'
default['logstash_forwarder']['group'] = 'root'

# default['logstash_forwarder']['config']['network']['servers'] = []
# default['logstash_forwarder']['config']['network']['ssl certificate'] = '/etc/lumberjack.crt'
# default['logstash_forwarder']['config']['network']['ssl key'] = '/etc/lumberjack.key'
# default['logstash_forwarder']['config']['network']['ssl ca'] = '/etc/lumberjack.crt'
# default['logstash_forwarder']['config']['network']['timeout'] = 15
