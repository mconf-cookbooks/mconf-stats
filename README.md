mconf-stats Cookbook
=================

Installs Mconf-stats - Mconf's Elastic stack ([Beats](https://www.elastic.co/products/beats), [Elasticsearch](https://www.elastic.co/products/elasticsearch), [Logstash](https://www.elastic.co/products/logstash), [Kibana](https://www.elastic.co/products/kibana)).

Requirements
------------

Filebeat and Packetbeat tested on Ubuntu 14.04.
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

Recipes
-----

#### default

Default recipe. It installs Logstash, Elasticsearch and Kibana on the same machine.
Other packages are also installed (eg., Node.JS and Elasticdump).

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

The secrets for Lumberjack (for securing Logstash inputs) are expected to be at a data bag `lumberjack/secrets.json` by default.

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

#### Other Recipes

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
