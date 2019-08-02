require 'simplecov'
require 'yaml'

SimpleCov.start do
  add_filter '/spec/' 
end


RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

def load_spec_conf
  base_path = File.join(File.dirname(__FILE__), 'config')
  cfg_path  = File.join(base_path, 'spec-conf.yml')
  YAML.load_file(cfg_path)
end
