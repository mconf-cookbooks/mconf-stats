require "chef/search/query"
require "json"

# Elasticdump command to import files (mainly JSON) into Elasticsearch
# It is useful for importing Kibana configurations and objects (searches,
# visualizations and dashboards) into Kibana's index in Elasticsearch (often
# called .kibana)
class Elasticdump
  def self.import_objects(filepath, host, index)
    json_objects = ::File.read(filepath)
    json_array = JSON::parse(json_objects)
    tmp_file = "object_tmp.json"

    json_array.each do |obj|

      ::File.open(tmp_file, 'w') do |tmp|
        tmp.write(JSON.pretty_generate(obj))
      end

      system "elasticdump --input=#{tmp_file} --output=#{host}/#{index} --type=data"
    end

    ::File.delete(tmp_file)
  end
end
