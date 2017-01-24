require "chef/search/query"

# Elasticdump command to import files (mainly JSON) into Elasticsearch
# It is useful for importing Kibana configurations and objects (searches,
# visualizations and dashboards) into Kibana's index in Elasticsearch (often
# called .kibana)
class Elasticdump
  def self.import_cmd(input_file, host, index)
    <<-EOH
      elasticdump \
        --input=#{input_file} \
        --output=#{host}/#{index} \
        --type=data
    EOH
  end
end
