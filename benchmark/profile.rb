require File.expand_path("crafty", File.dirname(__FILE__))

profiler = if RUBY_ENGINE == "rbx"
  Rubinius::Profiler::Instrumenter.new
else
  require "ruby-prof"
  RubyProf
end

result = profiler.profile do
  1000.times do
    crafty_simple("http://example.org/example/path")
  end
end

if RUBY_ENGINE != "rbx"
  printer = RubyProf::FlatPrinter.new(result)
  printer.print
end
