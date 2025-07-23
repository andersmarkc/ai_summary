# frozen_string_literal: true

require_relative "ai_summary/version"
require_relative "ai_summary/summary_generator"

# Auto-load Rake tasks
task_file = File.expand_path("../tasks/ai_summary.rake", __FILE__)
load task_file if defined?(Rake)

module AiSummary
  class Error < StandardError; end
  # Your code goes here...
end
