mconf-stats Cookbook
=================

Installs Mconf-Stats - Mconf's Elastic stack ([Beats](https://www.elastic.co/products/beats), [Elasticsearch](https://www.elastic.co/products/elasticsearch), [Logstash](https://www.elastic.co/products/logstash), [Kibana](https://www.elastic.co/products/kibana)).

Requirements
------------

Filebeat and Packetbeat tested on Ubuntu 14.04 and 16.04.  
Other componentes tested on Ubuntu 16.04.

It has been tested with Chef 12.5.1, but should work with Chef 12.X as well.

Supported versions
-----

The versions currently supported by this cookbook are:

* Filebeat: 5.1.2.
* Packetbeat: 5.1.2.
* Logstash: 5.1.2.
* Elasticsearch: 5.1.2.
* Kibana: 5.1.2.
* Elasticdump: 3.0.2.

Attributes
-----

All the following attributes can be overriden on Chef's `solo.json`, but be consistent. Tweak defaults only if you know what you're doing. The configurations you're most likely to modify are shown in _Recipes_ section.

#### Beats

Some configurations are the same for Filebeat and Packetbeat. For example, certificate and key names as well as package repository URL must be specified for Beats globally:

```
default['mconf-stats']['beats']['ssl_certificate'] = 'beats.crt'
default['mconf-stats']['beats']['ssl_key']         = 'beats.key'
default['mconf-stats']['beats']['apt']['uri']      = 'https://artifacts.elastic.co/packages/5.x/apt'
```

Other configurations are Beat-specific. For instance:

```
default['mconf-stats']['beats']['filebeat']['config_path'] = '/etc/filebeat/filebeat.yml'
```

and

```
default['mconf-stats']['beats']['packetbeat']['service_name'] = 'packetbeat'
```

Please, consult `beats.rb` for Beats-general attributes and `filebeat.rb` or `packetbeat.rb` for Beat-specific attributes.

#### Logstash

You can set Logstash's configurations such as directory paths:

```
default['mconf-stats']['logstash']['instance_bin']    = "#{node['mconf-stats']['logstash']['instance_home']}/bin"
default['mconf-stats']['logstash']['instance_config'] = "#{node['mconf-stats']['logstash']['instance_home']}/config"
```

and Elasticsearch destination:

```
default['mconf-stats']['logstash']['es_server'] = '127.0.0.1'
default['mconf-stats']['logstash']['es_port']   = '9200'
default['mconf-stats']['logstash']['es_index']  = 'logstash-%{+YYYY.MM.dd}'
```

> It's not necessary to modify Logstash's configuration at `override.rb`. Those are simply copies of default settings that are used by Logstash's cookbook.

For a full list of Logstash's attributes, see `default.rb`.

#### Elasticsearch

Elasticsearch's attributes can be set with:

```
default['mconf-stats']['elasticsearch']['version']          = "5.1.2"
default['mconf-stats']['elasticsearch']['allocated_memory'] = "256m"
default['mconf-stats']['elasticsearch']['cluster']['name']  = "mconf-cluster"
```

> Again, there is no need to change attributes at `override.rb` for the same reason explained above.

For a full list of Elasticsearch's attributes, see `default.rb`.

#### Kibana

Finally, you can set Kibana's attributes as well:

```
default['mconf-stats']['kibana']['basedir'] = '/opt'
default['mconf-stats']['kibana']['version'] = '5.1.2'
```

The Elasticsearch's instance from where Kibana must retrieve data can be set with:

```
default['mconf-stats']['kibana']['es_index']  = '.kibana'
default['mconf-stats']['kibana']['es_server'] = '127.0.0.1'
```

> Don't change `override.rb`, you know.

For a full list of Kibana's attributes, see `default.rb`.

#### Others

You can also set Elasticdump's version:

```
default['mconf-stats']['elasticdump']['version'] = '3.0.2'
```

on `default.rb`.

Recipes
-----

#### default

Default recipe. It installs Logstash, Elasticsearch and Kibana on the same machine.
Other packages are also installed (eg., Node.js and Elasticdump).

Configuration example:

```json
{
  "mconf": {
    "user": "vagrant",
    "app_group": "vagrant"
  },
  "mconf-stats": {
    "domain": "10.0.1.2",
    "logstash": {
      "debug": true,
      "user_configs": "logstash_configs",
      "user_templates": "logstash_templates",
      "inputs": {
        "lumberjack": {
          "ssl_ca": ["certificate-authority.your.domain.crt"]
        }
      },
      "plugins": ["logstash-filter-elasticsearch"],
      "es_server": "elasticsearch-server.your.domain",
      "es_port": "9200",
      "es_index": "logstash-%{+YYYY.MM.dd}",
      "es_template": "index-template-name"
    },
    "elasticsearch": {
      "allocated_memory": "256m",
      "cluster": {
        "name": "mconf_cluster"
      },
      "disk_threshold": {
          "enabled": false
      }
    },
    "kibana": {
      "bind_interface": "127.0.0.1",
      "es_server": "elasticsearch-server.your.domain",
      "es_index": ".kibana"
    }
  },

  "description": "Elastic stack server",

  "override_attributes": {
  },

  "name": "my-mconf-stats",
  "run_list": [
    "recipe[mconf-stats::default]"
  ]
}
```

The secrets for Lumberjack (for securing Logstash inputs) are expected to be at a *data_bag* `lumberjack/secrets.json` by default.

#### beats

It installs Filebeat and Packetbeat on the same machine.

Configuration example:

```json
{
  "mconf": {
    "user": "vagrant",
    "app_group": "vagrant"
  },
  "mconf-stats": {
    "domain": "10.0.1.1",
    "beats": {
      "logstash_host": "logstash-server.your.domain:5044",
      "redis_port": "6379",
      "install_packetbeat": true,
      "install_filebeat": true,
      "filebeat": {
        "prospectors": [
          {
            "paths": ["/path/to/files.xml"],
            "options": {
                "multiline.pattern": "'\\<?xml\\<'",
                "multiline.negate": true,
                "multiline.match": "after"
            },
            "ignore_older": "24h",
            "input_type": "log",
            "document_type": "my_files"
          },
          {
            "paths": ["/path/to/other/files1/*", "/path/to/other/files2/*"],
            "input_type": "log",
            "document_type": "my_other_files"
          },
          {
            "paths": ["/still/other/files"],
            "input_type": "log",
            "document_type": "still_other_files"
          }
        ]
      }
    }
  },

  "description": "Beats monitored server",

  "override_attributes": {
  },

  "name": "my-mconf-beats",
  "run_list": [
    "recipe[mconf-stats::beats]"
  ]
}
```

#### Other recipes

It is also possible to install just one component or another by using the appropriate recipe.
The individual available recipes are:

* _mconf-stats::filebeat_
* _mconf-stats::packetbeat_
* _mconf-stats::logstash-server_
* _mconf-stats::elasticsearch_
* _mconf-stats::kibana_

For instance, you can install only Logstash by adding:

```json
"run_list": ["recipe[mconf-stats::logstash-server]"]
```

on your `solo.json`. The settings are the same as those shown above.

> Note that it is _logstash-server_, not just _logstash_.

Security
-----

To enable SSL communication between Beats (Filebeat and Packetbeat) and Logstash, you can set SSL certificates and keys.

Those sensitive information must be in a Base64-encoded file as following:

* `data_bags/beats/secrets.json` # Beats
* `data_bags/lumberjack/secrets.json` # Logstash

Each JSON file must have four fields with the following format:

```json
{
    "id": "secrets",
    "key": "LH0...",
    "certificate": "L1J...",
    "ca": ["LHS..."]
}
```

where

* `"id"`: default value is _secrets_, although it can be set to anything else on attributes.
* `"key"`: Base64-encoded SSL key (used to generate the certificate) file content.
* `"certificate"`: Base64-encoded certificate file content.
* `"ca"`: array with certificate-authorities file content encoded in Base64. In most real use cases, it'll have only one element.

> Tip: you can use Ruby Base64's class method `Base64.encode64()` to encode a file in Base64 format.

The recipes will load the respective *data_bag*, decode it from Base64 into a regular file and place it where the attributes point to:

```
# Beats
default['mconf-stats']['beats']['ssl_certificate'] = 'beats.crt'
default['mconf-stats']['beats']['ssl_key']         = 'beats.key'
default['mconf-stats']['beats']['ssl_ca']          = ['CA.crt']

# Logstash
default['mconf-stats']['logstash']['inputs']['lumberjack']['ssl_ca']          = ['CA.crt']
default['mconf-stats']['logstash']['inputs']['lumberjack']['ssl_certificate'] = 'lumberjack.crt'
default['mconf-stats']['logstash']['inputs']['lumberjack']['ssl_key']         = 'lumberjack.key'
```

This should be enough to get secure communication up and running.

> In fact, the recipe will only work if SSL is correctly set.

Files, templates and data bags
-----

Regarding to Beats, there's only one file to be included, `secrets.json`, as mentioned in _Security_ section.

Logstash demands more files than just `secrets.json` (as explained in _Security_). Logstash's inputs, filters and outputs should be included in:

* `files/default/logstash_configs/`
* `templates/default/logstash/logstash_configs/`

The former path should be used for configurations that are static. The latter is for configurations that have variable attributes (such as Elasticsearch's address).

Logstash can also be configured to use Elasticsearch's index templates. The index template JSON file must be placed at `files/default/logstash_templates/`.

Kibana's configurations and objects (searches, visualizations and dashboards) can be imported into a Kibana's running instance. The JSON files must be placed at `data_bags/kibana/`. All files in this directory are imported into Kibana.
