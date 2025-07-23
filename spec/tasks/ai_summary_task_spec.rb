# frozen_string_literal: true
require "rails_helper"

RSpec.describe "ai_summary:generate" do
  it "executes the rake task successfully" do
    expect {
      Rake::Task["ai_summary:generate"].reenable
      Rake::Task["ai_summary:generate"].invoke
    }.to output(/✅ AI Summary generated/).to_stdout
  end
end
