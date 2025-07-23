# frozen_string_literal: true

require "json"
require "yaml"

module AiSummary
  class SummaryGenerator
    def self.generate(format: "txt")
      # Ensure models are loaded
      Dir[Rails.root.join("app/models/**/*.rb")].sort.each { |file| require_dependency file }

      data = {
        models: extract_models,
        routes: extract_routes,
        controllers: extract_controllers
      }

      case format.downcase
      when "json"
        File.write("rails_summary.json", JSON.pretty_generate(data))
        puts "✅ AI Summary generated in rails_summary.json"
      when "yaml", "yml"
        File.write("rails_summary.yaml", data.to_yaml)
        puts "✅ AI Summary generated in rails_summary.yaml"
      else
        File.write("rails_summary.txt", format_txt(data))
        puts "✅ AI Summary generated in rails_summary.txt"
      end
    end

    def self.extract_models
      ActiveRecord::Base.descendants.reject { |m| m.abstract_class? || !m.table_exists? }.map do |model|
        {
          name: model.name,
          table: model.table_name,
          columns: model.columns.map { |col| { name: col.name, type: col.type } },
          associations: model.reflect_on_all_associations.map { |assoc| { type: assoc.macro, name: assoc.name } }
        }
      end
    end

    def self.extract_routes
      Rails.application.routes.routes.map do |r|
        verb = r.verb&.gsub(/\W/, "")
        next unless r.defaults[:controller] && r.defaults[:action]

        {
          verb: verb,
          path: r.path.spec.to_s,
          controller: r.defaults[:controller],
          action: r.defaults[:action]
        }
      end.compact
    end

    def self.extract_controllers
      Dir.glob(Rails.root.join("app/controllers/**/*_controller.rb")).map do |file|
        class_name = File.basename(file, ".rb").camelize
        klass = class_name.safe_constantize
        next unless klass.is_a?(Class)
        {
          name: klass.name,
          actions: klass.public_instance_methods(false).map(&:to_s)
        }
      end.compact
    end

    def self.format_txt(data)
      lines = []

      lines << "# MODELS"
      data[:models].each do |model|
        lines << "#{model[:name]} (table: #{model[:table]})"
        model[:columns].each { |col| lines << "  - #{col[:name]}: #{col[:type]}" }
        model[:associations].each { |assoc| lines << "  - #{assoc[:type]} :#{assoc[:name]}" }
        lines << ""
      end

      lines << "# ROUTES"
      data[:routes].each do |route|
        lines << "#{route[:verb].to_s.ljust(6)} #{route[:path]} => #{route[:controller]}##{route[:action]}"
      end

      lines << "# CONTROLLERS"
      data[:controllers].each do |ctrl|
        lines << ctrl[:name]
        ctrl[:actions].each { |action| lines << "  - #{action}" }
        lines << ""
      end

      lines.join("\n")
    end
  end
end
