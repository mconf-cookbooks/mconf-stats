mconf-stats Cookbook
=================

Install Mconf-Stats, Mconf's ELK stack ([ElasticSearch](https://www.elastic.co/products/elasticsearch), [Logstash](https://www.elastic.co/products/logstash), [Kibana](https://www.elastic.co/products/kibana)).

Requirements
------------

Tested on Ubuntu 14.04.

Usage
-----

#### mconf-stats::default

Configuration example:

```json
{
  "mconf": {
    "user": "vagrant",
    "app_group": "vagrant"
  },
  "mconf-stats": {
    "domain": "10.0.3.2",
    "logstash": {
      "debug": true,
      "inputs": {
        "lumberjack": {
          "name": "1-input-lumberjack.conf"
        }
      },
      "outputs": {
        "elasticsearch": [
          {
            "name": "8-output-elasticsearch.conf",
            "host": "localhost",
            "cluster": "mconf_cluster",
            "embedded": false,
            "bind_host": null,
            "es_index": null
          }
        ],
        "stdout": {
          "name": "9-output-stdout.conf",
          "codec": "rubydebug"
        }
      }
    },
    "elasticsearch": {
      "cluster": {
        "name": "mconf_cluster"
      }
    }
  },
  "description": "My mconf-stats server",
  "override_attributes": {
  },
  "name": "my-mconf-stats",
  "run_list": [
    "recipe[mconf-stats::default]"
  ]
}
```

The secrets for lumberjack are expected to be at a data bag `logstash-forwarder/secrets.json` by default.

#### mconf-stats::forwarder

Configuration example:

```json
{
  "mconf": {
    "user": "vagrant",
    "app_group": "vagrant"
  },
  "mconf-stats": {
    "domain": "10.0.3.1",
    "logstash-forwarder": {
      "logstash_servers": [ "fake-elk.test.local:5960" ],
      "logstash_servers_mappings": {
        "10.0.3.2": "fake-elk.test.local"
      },
      "logs": [
        {
          "name": "mconf-web",
          "paths": ["/var/www/mconf-web/current/log/lograge_development.log"],
          "fields": { "types": "rails" }
        }
      ]
    }
  },
  "description": "Log forwarder on my mconf-web",
  "override_attributes": {
  },
  "name": "my-mconf-web-solo-forwarder",
  "run_list": [
    "recipe[mconf-stats::forwarder]"
  ]
}
```

The secrets for lumberjack are expected to be at a data bag `logstash-forwarder/secrets.json` by default.
