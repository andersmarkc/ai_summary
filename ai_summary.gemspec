# frozen_string_literal: true

require_relative "lib/ai_summary/version"

Gem::Specification.new do |spec|
  spec.name          = "ai_summary"
  spec.version       = AiSummary::VERSION
  spec.authors       = ["Anders Jonassen"]
  spec.email         = ["andersmarkc@gmail.com"]

  spec.summary       = "Generate a structured summary of your Rails codebase for AI-assisted workflows."
  spec.description   = "AI Summary is a Ruby gem that inspects your Rails project and generates a developer-friendly summary of your models, tables, controllers, routes, and more. Designed to help AI tools understand your application structure for better code suggestions, onboarding, debugging, or documentation."

  spec.homepage      = "https://github.com/andersmarkc/ai_summary"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"]      = spec.homepage
  spec.metadata["source_code_uri"]   = "https://github.com/andersmarkc/ai_summary"
  spec.metadata["changelog_uri"]     = "https://github.com/andersmarkc/ai_summary/blob/main/CHANGELOG.md"

  spec.files         = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == File.basename(__FILE__)) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/])
    end
  end
  spec.files += Dir["tasks/**/*.rake"]

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "rails", ">= 7.1", "< 9.0"
  spec.add_dependency "activerecord", ">= 7.1", "< 9.0"
  spec.add_dependency "activesupport", ">= 7.1", "< 9.0"

  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "bundler", "~> 2.4"
end
