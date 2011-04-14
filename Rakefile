# encoding: utf-8
require "jeweler"
require "rake/testtask"

Jeweler::Tasks.new do |spec|
  spec.name = "crafty"
  spec.summary = "Build HTML like a master craftsman."
  spec.description = "Crafty provides you the tools to easily and flexibly create HTML output with pure Ruby."

  spec.authors = ["Rolf Timmermans"]
  spec.email = "r.timmermans@voormedia.com"

  spec.files -= Dir["{benchmark,src,site}/**/*"]
end

Jeweler::GemcutterTasks.new

Rake::TestTask.new do |test|
  test.pattern = "test/unit/**/*_test.rb"
end

task :default => [:generate, :test]

desc "Benchmark Crafty against various other HTML builders"
task :bench do
  require File.expand_path("benchmark/bench", File.dirname(__FILE__))
end

desc "Profile Crafty"
task :profile do
  require File.expand_path("benchmark/profile", File.dirname(__FILE__))
end

desc "Regenerate toolsets"
task :generate do
  require File.expand_path("src/elements", File.dirname(__FILE__))

  def simple_format(text, len = 73, indent = 6)
    sentences = [[]]

    text.split.each do |word|
      if (sentences.last + [word]).join(' ').length > len
        sentences << [word]
      else
        sentences.last << word
      end
    end

    sentences.map { |sentence|
      "#{" " * indent}#{sentence.join(' ')}"
    }.join "\n"
  end

  def define(set, regular, empty)
    simple_format("Toolset.define(self, %w{#{regular * " "}}" + (empty.any? ? ", %w{#{empty * " "}}" : "") + ")")
  end

  def create_set(version, set, elements)
    path = "crafty/toolsets/#{version.to_s.downcase}/#{set.to_s.downcase}"
    file = File.open("lib/#{path}.rb", "w+")
    file.puts "module Crafty"
    file.puts "  # This toolset has been automatically generated."
    file.puts "  module #{version}"
    file.puts "    module #{set}"
    file.puts define(set, elements - Childless, elements & Childless)
    file.puts "    end"
    file.puts "  end"
    file.puts "  # End of generated code."
    file.puts "end"
    file.close
    [set, path]
  end

  def create_builder(version, set)
    path = "crafty/toolsets/#{version.to_s.downcase}/builder"
    file = File.open("lib/#{path}.rb", "w+")
    file.puts "module Crafty"
    file.puts "  # This builder has been automatically generated."
    file.puts "  module #{version}"
    file.puts "    class Builder < Crafty::Builder"
    file.puts "      include #{set}"
    file.puts "    end"
    file.puts "  end"
    file.puts "  # End of generated code."
    file.puts "end"
    file.close
    [:Builder, path]
  end

  Versions.each do |version|
    version_elements = Object.const_get(version)

    sets = []
    sets << create_set(version, :All, version_elements)
    sets += Sets.collect do |set|
      set_elements = Object.const_get(set)
      broken = set_elements - (HTML4 + HTML5)
      raise "Incorrect elements in set: #{broken}" if broken.any?
      create_set(version, set, version_elements & set_elements)
    end
    sets << create_builder(version, :All)

    autoloading = [
      "    # These load paths have been automatically generated.",
      *(sets.collect { |set, path| %Q(    autoload :#{set}, "#{path}") }),
      "    # End of generated code."] * "\n"

    version_file = "lib/crafty/toolsets/#{version.to_s.downcase}.rb"

    mod = File.read(version_file)
    file = File.open(version_file, "w+")
    file.write mod.sub(/(  module #{version}\n).*?\n?(  end)/m, "\\1#{autoloading}\n\\2")
    file.close
  end
end
