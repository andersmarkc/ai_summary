# lib/ai_summary/railtie.rb
require "rails/railtie"

module AiSummary
  class Railtie < Rails::Railtie
    rake_tasks do
      rake_file = File.expand_path("../../../lib/tasks/ai_summary.rake", __FILE__)
      load rake_file if File.exist?(rake_file)
    end
  end
end
