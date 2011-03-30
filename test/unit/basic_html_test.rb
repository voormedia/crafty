require File.expand_path("../test_helper", File.dirname(__FILE__))

class BasicHTMLTest < Test::Unit::TestCase
  def setup
    @object = Class.new { include Artisan::BasicHTML }.new
  end

  # Simple methods ===========================================================
  test "h1 should return h1 header" do
    assert_equal %Q{<h1>Title</h1>}, @object.h1 { "Title" }
  end
end
