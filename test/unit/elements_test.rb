require File.expand_path("../test_helper", File.dirname(__FILE__))

class Object
  def html_safe
    obj = dup
    class << obj
      def html_safe?; true; end
    end
    obj
  end
end

class ElementsTest < Test::Unit::TestCase
  def setup
    @object = Class.new { include Artisan::Elements }.new
  end

  # Basic element functionality ==============================================
  test "element should return element with given name" do
    assert_equal %Q{<el/>}, @object.element!("el")
  end

  test "element should return element with given name and content" do
    assert_equal %Q{<el>content</el>}, @object.element!("el") { "content" }
  end

  test "element should return element with given name and no content" do
    assert_equal %Q{<el></el>}, @object.element!("el") { nil }
  end

  test "element should return element with given name and blank content" do
    assert_equal %Q{<el></el>}, @object.element!("el") { "" }
  end

  test "element should return element with given name and attributes" do
    assert_equal %Q{<el attr="val" prop="value"/>},
      @object.element!("el", :attr => "val", :prop => "value")
  end

  test "element should return element with given name and attributes and content" do
    assert_equal %Q{<el attr="val" prop="value">content</el>},
      @object.element!("el", :attr => "val", :prop => "value") { "content" }
  end

  # Escaping =================================================================
  test "element should return element with given name and escaped content" do
    assert_equal %Q{<el>content &amp; &quot;info&quot; &lt; &gt;</el>},
      @object.element!("el") { %Q{content & "info" < >} }
  end

  test "element should return element with given name and escaped attributes" do
    assert_equal %Q{<el name="&quot;attrib&quot;" prop="a &gt; 1 &amp; b &lt; 4"/>},
      @object.element!("el", :name => %Q{"attrib"}, :prop => "a > 1 & b < 4")
  end

  test "element should not escape content that has been marked as html safe" do
    html = "<safe></safe>".html_safe
    assert_equal %Q{<el><safe></safe></el>}, @object.element!("el") { html }
  end

  test "element should not escape attributes that have been marked as html safe" do
    html = "http://example.org/?q=example&amp;a=search".html_safe
    assert_equal %Q{<el attr="http://example.org/?q=example&amp;a=search"/>}, @object.element!("el", :attr => html)
  end

  test "element should return html safe string" do
    assert_equal true, @object.element!("el").html_safe?
  end

  test "element should return string that reamins html safe when calling to_s" do
    assert_equal true, @object.element!("el").to_s.html_safe?
  end

  # Building =================================================================
  test "element should be nestable" do
    assert_equal %Q{<el><nested>content</nested></el>},
      @object.element!("el") { @object.element!("nested") { "content" } }
  end

  test "element should be nestable and chainable without concatenation" do
    assert_equal %Q{<el><nest>content</nest><nested>more content</nested></el>},
      @object.element!("el") {
        @object.element!("nest") { "content" }
        @object.element!("nested") { "more content" }
      }
  end

  test "element should be reset state of buffer after being called" do
    assert_equal %Q{<el/><el/>},
      @object.element!("el") + @object.element!("el")
  end

  test "element should append to object that responds to arrows" do
    object = Class.new(Array) { include Artisan::Elements }.new
    assert_equal ["<el>", "<nest>", "content", "</nest>", "<nested>", "more content", "</nested>", "</el>"],
      object.element!("el") {
        object.element!("nest") { "content" }
        object.element!("nested") { "more content" }
      }
  end
end
