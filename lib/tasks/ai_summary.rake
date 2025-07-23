# frozen_string_literal: true

namespace :ai_summary do
  desc "Generate AI Summary of your Rails app. Optionally specify FORMAT=json or FORMAT=yaml"
  task :generate, [:format] => :environment do |t, args|
    format = args[:format]&.downcase || "txt"
    AiSummary::SummaryGenerator.generate(format: format)
  end
end
