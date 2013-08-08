Tire.configure{ logger 'log/elasticsearch.log', :level => 'debug' } if Rails.env.development?
Tire::Model::Search.index_prefix 'phonebook_test' if Rails.env.test?
Phone.create_elasticsearch_index unless Phone.index.exists?
