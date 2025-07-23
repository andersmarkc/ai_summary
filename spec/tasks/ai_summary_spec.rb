# frozen_string_literal: true

require "rails_helper"
require "rake"

RSpec.describe "ai_summary:generate" do
  before :all do
    Rake.application.rake_require("tasks/ai_summary", [File.expand_path("../../../lib", __FILE__)])
    Rake::Task.define_task(:environment)
  end

  it "generates a txt file by default" do
    File.delete("rails_summary.txt") if File.exist?("rails_summary.txt")
    Rake::Task["ai_summary:generate"].invoke
    expect(File.exist?("rails_summary.txt")).to be true
    content = File.read("rails_summary.txt")
    expect(content).to include("# MODELS")
    expect(content).to include("# ROUTES")
    expect(content).to include("# CONTROLLERS")
  end
end
