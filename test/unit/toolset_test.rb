require File.expand_path("../test_helper", File.dirname(__FILE__))

class ToolsetTest < Test::Unit::TestCase
  def setup
    @toolset = Artisan::Toolset.create(%w{a b c d})
  end

  # Basic functionality ======================================================
  test "toolset should include methods" do
    toolset = @toolset
    object = Class.new { include toolset }.new
    assert_equal "<a></a>", object.a {}
  end

  test "toolset should include elements" do
    toolset = @toolset
    object = Class.new { include toolset }.new
    assert_equal "<x/>", object.element!("x")
  end

  # No conflicts =============================================================
  test "toolset should not override existing method" do
    toolset = @toolset
    object = Class.new do
      def b; end
      include toolset
    end.new
    assert_equal nil, object.b {}
  end

  test "toolset should not override existing method when included twice" do
    toolset = @toolset
    object = Class.new do
      def b; end
      include toolset
      include toolset
    end.new
    assert_equal nil, object.b {}
  end

  test "toolset should not override existing method from ancestor" do
    toolset = @toolset
    conflict = Module.new do
      def b; end
    end
    object = Class.new do
      include conflict
      include toolset
    end.new
    assert_equal nil, object.b {}
  end
end
