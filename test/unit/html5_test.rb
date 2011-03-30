require File.expand_path("../test_helper", File.dirname(__FILE__))

class HTML5Test < Test::Unit::TestCase
  def setup
    @object = Class.new { include Artisan::HTML5 }.new
  end

  test "a should return anchor with given attributes" do
    assert_equal %Q{<a href="http://example.org">link</a>},
      @object.a(:href => "http://example.org") { "link" }
  end
end
