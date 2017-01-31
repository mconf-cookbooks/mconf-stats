# Beats

# Beats generic settings
default['mconf-stats']['beats']['install_certificates'] = true
default['mconf-stats']['beats']['install_packetbeat']   = false
default['mconf-stats']['beats']['install_filebeat']     = false
default['mconf-stats']['beats']['install_topbeat']      = false
default['mconf-stats']['beats']['logstash_host']        = '127.0.0.1:5044'
default['mconf-stats']['beats']['redis_port']           = '6379'
default['mconf-stats']['beats']['certificate_path']     = "/opt/beats/certs"
default['mconf-stats']['beats']['ssl_certificate']      = 'beats.crt'
default['mconf-stats']['beats']['ssl_key']              = 'beats.key'
default['mconf-stats']['beats']['ssl_ca']               = ['CA.crt']
default['mconf-stats']['beats']['data_bag']             = 'beats'
default['mconf-stats']['beats']['data_item']            = 'secrets'
default['mconf-stats']['beats']['apt']['uri']           = 'https://artifacts.elastic.co/packages/5.x/apt'
default['mconf-stats']['beats']['apt']['description']   = 'Elastic Beats Repository'
default['mconf-stats']['beats']['apt']['components']    = %w(stable main)
default['mconf-stats']['beats']['apt']['distribution']  = ''
default['mconf-stats']['beats']['apt']['action']        = :add
default['mconf-stats']['beats']['apt']['key']           = 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
