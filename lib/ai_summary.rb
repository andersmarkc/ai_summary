# lib/ai_summary.rb
# frozen_string_literal: true

require_relative "ai_summary/version"
require_relative "ai_summary/summary_generator"

module AiSummary
  class Error < StandardError; end
end
require_relative "ai_summary/railtie" if defined?(Rails::Railtie)
