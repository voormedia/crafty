require "rubygems"
require "bundler/setup"
require "test/unit"
require "artisan"

class Test::Unit::TestCase
  class << self
    # Support declarative specification of test methods.
    def test(name)
      define_method "test_#{name.gsub(/\s+/,'_')}".to_sym, &Proc.new
    end
  end
end
