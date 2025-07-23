# AiSummary

**AI-powered summary generator for Ruby on Rails applications.**  
`AiSummary` scans your Rails project and creates a structured summary of your models, database tables, associations, controllers, and routes. It’s designed to help AI tools (like ChatGPT or GitHub Copilot) better understand your codebase for debugging, refactoring, onboarding, or generating code.

---

## ✨ Features

- Lists all models and their database columns
- Extracts ActiveRecord associations (`has_many`, `belongs_to`, etc.)
- Summarizes all controllers and public methods
- Extracts and maps all routes to their controller actions
- Outputs a clean `.txt` file (YAML and JSON output planned)
- Useful for documentation, developer onboarding, and AI integration

---

## 📦 Installation

After it's released to [RubyGems.org](https://rubygems.org/gems/ai_summary), add it to your Gemfile:
bundle add ai_summary
Or install it manually:
gem install ai_summary
If you want to use the gem directly from GitHub before release:
gem 'ai_summary', git: 'https://github.com/andersmarkc/ai_summary'
Then run:
bundle install

## 🚀 Usage
# Rails Runner
bundle exec rails runner 'AiSummary::SummaryGenerator.generate'

# Rails Console
AiSummary::SummaryGenerator.generate

# Rake Task
bundle exec rake ai_summary:generate                # Default output: rails_summary.txt
bundle exec rake ai_summary:generate[json]         # Output: rails_summary.json
bundle exec rake ai_summary:generate[yaml]         # Output: rails_summary.yaml

By default, this will generate a rails_summary.txt file in your project root.

## 📂 Output Example
# MODELS
User (table: users)
  - id: integer
  - email: string
  - created_at: datetime
  - has_many :orders

Order (table: orders)
  - id: integer
  - user_id: integer
  - total_price: decimal
  - belongs_to :user

# CONTROLLERS
UsersController
  - index
  - show

OrdersController
  - create
  - update

# ROUTES
GET    /users          => users#index
GET    /users/:id      => users#show
POST   /orders         => orders#create
PATCH  /orders/:id     => orders#update


## 🤝 Contributing
Bug reports and pull requests are welcome on GitHub at
https://github.com/andersmarkc/ai_summary

This project is intended to be a safe, welcoming space for collaboration. Contributors are expected to follow the Code of Conduct.

## 📜 License
The gem is available as open source under the terms of the MIT License.



