require "chef/search/query"

class Elasticdump
  def self.import_cmd(input_file, host, index)
    <<-EOH
      elasticdump \
        --input=#{input_file} \
        --output=http://#{host}/#{index} \
        --type=data
    EOH
  end
end
