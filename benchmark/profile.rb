require "ruby-prof"
require File.expand_path("crafty", File.dirname(__FILE__))

result = RubyProf.profile do
  1000.times do
    crafty_simple("http://example.org/example/path")
  end
end

printer = RubyProf::FlatPrinter.new(result)
printer.print
