# lib/ai_summary/railtie.rb
require "rails/railtie"

module AiSummary
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.expand_path("../../tasks/ai_summary.rake", __dir__)
    end
  end
end
