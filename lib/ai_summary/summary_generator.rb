# frozen_string_literal: true

require "json"
require "yaml"
require "bundler"

module AiSummary
  class SummaryGenerator
    def self.generate(format: "txt")
      Dir[Rails.root.join("app/models/**/*.rb")].sort.each { |file| require_dependency file }

      data = {
        models: extract_models,
        routes: extract_routes,
        controllers: extract_controllers,
        jobs: extract_jobs,
        services: extract_services,
        gems: extract_gems
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
          associations: model.reflect_on_all_associations.map { |assoc| { type: assoc.macro, name: assoc.name } },
          methods: model.public_instance_methods(false).map(&:to_s).sort,
          validations: extract_validations(model),
          scopes: model.respond_to?(:defined_scopes) ? model.defined_scopes.map(&:to_s) : [],
          indexes: ActiveRecord::Base.connection.indexes(model.table_name).map(&:name)
        }
      end
    end

    def self.extract_validations(model)
      model.validators.map do |validator|
        {
          type: validator.class.name.demodulize,
          attributes: validator.attributes
        }
      end
    end

    def self.extract_routes
      Rails.application.routes.routes.map do |r|
        verb = r.verb&.gsub(/\W/, "")
        next unless r.defaults[:controller] && r.defaults[:action]

        {
          name: r.name,
          verb: verb,
          path: r.path.spec.to_s,
          controller: r.defaults[:controller],
          action: r.defaults[:action],
          constraints: r.constraints.map { |k, v| "#{k}: #{v}" }
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
          actions: klass.public_instance_methods(false).map(&:to_s),
          filters: klass.respond_to?(:_process_action_callbacks) ? klass._process_action_callbacks.map(&:filter).uniq.map(&:to_s) : []
        }
      end.compact
    end

    def self.extract_jobs
      Dir.glob(Rails.root.join("app/jobs/**/*.rb")).map do |file|
        name = File.basename(file, ".rb").camelize
        klass = name.safe_constantize
        next unless klass&.ancestors&.include?(ActiveJob::Base)

        { name: klass.name }
      end.compact
    end

    def self.extract_services
      Dir.glob(Rails.root.join("app/services/**/*.rb")).map do |file|
        File.basename(file, ".rb").camelize
      end
    end

    def self.extract_gems
      Bundler.load.specs.map(&:name).sort.uniq.take(25) # limit for size
    end

    def self.format_txt(data)
      lines = []

      lines << "# MODELS"
      data[:models].each do |model|
        lines << "#{model[:name]} (table: #{model[:table]})"
        lines << "  Attributes:"
        model[:columns].each { |col| lines << "    - #{col[:name]}: #{col[:type]}" }
        lines << "  Associations:"
        model[:associations].each { |assoc| lines << "    - #{assoc[:type]} :#{assoc[:name]}" }
        lines << "  Validations:"
        model[:validations].each { |v| lines << "    - #{v[:type]} on #{v[:attributes].join(', ')}" }
        lines << "  Scopes:"
        model[:scopes].each { |s| lines << "    - #{s}" }
        lines << "  Indexes:"
        model[:indexes].each { |i| lines << "    - #{i}" }
        lines << "  Methods:"
        model[:methods].each { |method| lines << "    - #{method}" }
        lines << ""
      end

      lines << "# ROUTES"
      data[:routes].each do |route|
        lines << "#{route[:verb].to_s.ljust(6)} #{route[:path]} => #{route[:controller]}##{route[:action]} (#{route[:name]})"
      end

      lines << ""
      lines << "# CONTROLLERS"
      data[:controllers].each do |ctrl|
        lines << ctrl[:name]
        lines << "  Filters:"
        ctrl[:filters].each { |f| lines << "    - #{f}" }
        lines << "  Actions:"
        ctrl[:actions].each { |a| lines << "    - #{a}" }
        lines << ""
      end

      lines << "# JOBS"
      data[:jobs].each do |job|
        lines << "- #{job[:name]}"
      end

      lines << ""
      lines << "# SERVICES"
      data[:services].each do |service|
        lines << "- #{service}"
      end

      lines << ""
      lines << "# GEMS"
      data[:gems].each do |gem|
        lines << "- #{gem}"
      end

      lines.join("\n")
    end
  end
end
