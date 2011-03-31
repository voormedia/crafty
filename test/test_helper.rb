require "rubygems"
require "bundler/setup"
require "test/unit"
require "crafty"

class Test::Unit::TestCase
  class << self
    # Support declarative specification of test methods.
    def test(name)
      define_method "test_#{name.gsub(/\s+/,'_')}".to_sym, &Proc.new
    end
  end
end

if RUBY_VERSION < "1.9"
  class Hash
    def each
      to_a.sort_by { |k, v| k.to_s }.each &Proc.new
    end
  end
end
