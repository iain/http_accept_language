if ENV.fetch("COVERAGE", false)
  require "simplecov"
  SimpleCov.start do
    load_profile "test_frameworks"
  end
end

require "action_controller/railtie"

Bundler.require :default, :development

Combustion.initialize! :action_controller do
  config.load_defaults Rails::VERSION::STRING.to_f
end

require "rspec/rails"

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = ".rspec_status"
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
end
