# encoding: utf-8
require "jeweler"
require "rake/testtask"

Jeweler::Tasks.new do |spec|
  spec.name = "crafty"
  spec.summary = "Build HTML like a master craftsman."
  spec.description = "Crafty provides you the tools to easily and flexibly create HTML output with pure Ruby."

  spec.authors = ["Rolf Timmermans"]
  spec.email = "r.timmermans@voormedia.com"
end

Rake::TestTask.new do |test|
  test.pattern = "test/unit/**/*_test.rb"
end

task :default => [:generate, :test]

desc "Benchmark Crafty against various other HTML builders"
task :bench do
  require File.expand_path("benchmark/bench", File.dirname(__FILE__))
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

  autoloading = ["  # Generated HTML toolsets."]
  Versions.each do |version|
    path = "crafty/toolsets/#{version.downcase}"
    file = File.open("lib/#{path}.rb", "w+")
    file.puts "module Crafty"
    file.puts "  # This toolset has been automatically generated."
    file.puts "  module #{version}"

    version_elements = Object.const_get(version)
    Sets.each do |set|
      set_elements = Object.const_get(set)

      broken = set_elements - (HTML4 + HTML5)
      raise "Incorrect elements in set: #{broken}" if broken.any?

      all = version_elements & set_elements

      file.puts "    module #{set}"
      file.puts define(set, all - Childless, all & Childless)
      file.puts "    end"
      file.puts
    end

    file.puts "    module All"
    file.puts define(:All, version_elements - Childless, version_elements & Childless)
    file.puts "    end"
    file.puts "  end"

    aliases = Aliases.select { |alt, orig| orig == version }.keys
    file.puts "\n  #{aliases * " = "} = #{version}" if aliases.any?
    file.puts "end"
    file.close

    ([version] + aliases).each do |mod|
      autoloading << %Q(  autoload #{mod.inspect}, #{path.inspect})
    end
    autoloading << ""
  end

  lib = File.read("lib/crafty.rb")
  lib.gsub!(/^\s*#\s*Generated.*\nend/m, "\n" + autoloading.join("\n") + "end")
  File.open "lib/crafty.rb", "w+" do |file|
    file.write lib
  end
end
