# encoding: utf-8
require "jeweler"
require "rake/testtask"

Jeweler::Tasks.new do |spec|
  spec.name = "artisan"
  spec.summary = "Artisan tools for HTML crafting."
  spec.description = "Artisan provides you the tools to easily and flexibly craft HTML output."

  spec.authors = ["Rolf Timmermans"]
  spec.email = "r.timmermans@voormedia.com"

  # Don't bundle examples or website in gem.
  excluded = Dir["{examples,site}/**/*"]
  spec.files -= excluded
  spec.test_files -= excluded
end

Rake::TestTask.new do |test|
  test.pattern = "test/unit/**/*_test.rb"
end

task :default => :test
