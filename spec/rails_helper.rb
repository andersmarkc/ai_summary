# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../dummy/config/environment", __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"

# Load support files
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

# Load the rake task
Rails.application.load_tasks

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # Uncomment below if you add fixtures later
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"
end
