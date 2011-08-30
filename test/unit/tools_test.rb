require File.expand_path("../test_helper", File.dirname(__FILE__))

class ToolsTest < Test::Unit::TestCase
  def setup
    @object = Class.new { include Crafty::Tools }.new
  end

  # Basic element functionality ==============================================
  test "element should return element with given name" do
    assert_equal %Q{<el/>}, @object.element!("el")
  end

  test "element should return element with given name and content" do
    assert_equal %Q{<el>content</el>}, @object.element!("el", "content")
  end

  test "element should return element with given name and non string content" do
    assert_equal %Q{<el>1234</el>}, @object.element!("el", 1234)
  end

  test "element should return element with given name and content in block" do
    assert_equal %Q{<el>content</el>}, @object.element!("el") { "content" }
  end

  test "element should return element with given name and non string content in block" do
    assert_equal %Q{<el>1234</el>}, @object.element!("el") { 1234 }
  end

  test "element should return element with given name and built content without non string block return value" do
    assert_equal %Q{<el><el>content</el><el>content</el></el>}, @object.element!("el") {
      2.times { @object.element!("el") { "content" } }
    }
  end

  test "element should return element with given name and built content with string block return value" do
    assert_equal %Q{<el><el>content</el>foo</el>}, @object.element!("el") {
      @object.element!("el") { "content" }
      "foo"
    }
  end

  test "element should return element with given name and no content" do
    assert_equal %Q{<el></el>}, @object.element!("el") { nil }
  end

  test "element should return element with given name and blank content" do
    assert_equal %Q{<el></el>}, @object.element!("el") { "" }
  end

  test "element should return element with given name and attributes" do
    assert_equal %Q{<el attr="val" prop="value"/>},
      @object.element!("el", nil, :attr => "val", :prop => "value")
  end

  test "element should return element with given name and attributes and content" do
    assert_equal %Q{<el attr="val" prop="value">content</el>},
      @object.element!("el", "content", :attr => "val", :prop => "value")
  end

  test "element should return element with given name and attributes and content in block" do
    assert_equal %Q{<el attr="val" prop="value">content</el>},
      @object.element!("el", nil, :attr => "val", :prop => "value") { "content" }
  end

  test "element should return element with given name and attributes with symbol values" do
    assert_equal %Q{<el attr="val"/>}, @object.element!("el", nil, :attr => :val)
  end

  # Advanced functionality ===================================================
  test "comment should return comment" do
    assert_equal "<!-- commented -->", @object.comment!("commented")
  end

  test "instruct should return xml processing instruction" do
    if RUBY_VERSION < "1.9"
      assert_equal %Q{<?xml encoding="UTF-8" version="1.0"?>}, @object.instruct!
    else
      assert_equal %Q{<?xml version="1.0" encoding="UTF-8"?>}, @object.instruct!
    end
  end

  test "instruct should return custom processing instruction" do
    assert_equal %Q{<?foo attr="instr"?>}, @object.instruct!("foo", :attr => "instr")
  end

  test "declare should return declaration" do
    assert_equal %Q{<!ENTITY greeting "Hello world">}, @object.declare!(:ENTITY, :greeting, "Hello world")
  end

  test "declare should return empty declaration if there are no parameters" do
    assert_equal %Q{<!ENTITY>}, @object.declare!("ENTITY")
  end

  test "text should append directly to output stream" do
    assert_equal %Q{foobar}, @object.text!("foobar")
  end

  test "write should append directly to output stream" do
    assert_equal %Q{foobar}, @object.write!("foobar")
  end

  test "build should collect output" do
    assert_equal %Q{<el/><el/>}, @object.build! {
      @object.element!("el")
      @object.element!("el")
    }
  end

  test "attribute values as array should be joined with spaces" do
    assert_equal %Q{<el attr="val1 val2 val3">content</el>},
      @object.element!("el", "content", :attr => ["val1", "val2", "val3"])
  end

  test "attribute values as array should be flattened and compacted and joined with spaces" do
    assert_equal %Q{<el attr="val1 val2 val3">content</el>},
      @object.element!("el", "content", :attr => ["val1", [[nil, "val2"], "val3"]])
  end

  test "attribute values as empty array should be omitted" do
    assert_equal %Q{<el>content</el>}, @object.element!("el", "content", :attr => [])
  end

  test "empty objects should not be rendered" do
    assert_equal %Q{<el></el>}, @object.element!("el", [])
  end

  # Escaping =================================================================
  test "element should return element with given name and escaped content" do
    assert_equal %Q{<el>content &amp; &quot;info&quot; &lt; &gt;</el>},
      @object.element!("el") { @object.write! %Q{content & "info" < >} }
  end

  test "element should return element with given name and escaped attributes" do
    assert_equal %Q{<el attr="&quot;attrib&quot;" prop="a &gt; 1 &amp; b &lt; 4"/>},
      @object.element!("el", nil, :attr => %Q{"attrib"}, :prop => "a > 1 & b < 4")
  end

  test "comment should return escaped comment" do
    assert_equal "<!-- remarked &amp; commented -->", @object.comment!("remarked & commented")
  end

  test "instruct should return instruction with escaped attributes" do
    assert_equal %Q{<?foo comment="1 &lt; 2"?>}, @object.instruct!("foo", :comment => "1 < 2")
  end

  test "write should escape output" do
    assert_equal %Q{foo &amp; bar}, @object.write!("foo & bar")
  end

  test "element should not escape content that has been marked as html safe" do
    html = Crafty::SafeString.new("<safe></safe>")
    assert_equal %Q{<el><safe></safe></el>}, @object.element!("el") { html }
  end

  test "element should not escape attributes that have been marked as html safe" do
    html = Crafty::SafeString.new("http://example.org/?q=example&amp;a=search")
    assert_equal %Q{<el attr="http://example.org/?q=example&amp;a=search"/>}, @object.element!("el", nil, :attr => html)
  end

  test "write should not escape output that has been marked as html safe" do
    assert_equal %Q{foo &amp; bar}, @object.write!(Crafty::SafeString.new("foo &amp; bar"))
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
    assert_equal %Q{<el><nest>content</nest><nested>more &amp; content</nested></el>},
      @object.element!("el") {
        @object.element!("nest") { "content" }
        @object.element!("nested") { "more & content" }
      }
  end

  test "element should be reset state of buffer after being called" do
    assert_equal %Q{<el/><el/>}, @object.element!("el") + @object.element!("el")
  end

  test "element should append to object that responds to arrows" do
    object = Class.new(Array) { include Crafty::Tools }.new
    object.element!("el") {
      object.element!("nest") { "content" }
      object.element!("nested") { "more & content" }
    }
    assert_equal ["<el>", "<nest>", "content", "</nest>", "<nested>", "more &amp; content", "</nested>", "</el>"], object
  end

  test "element should escape content if appending to object that responds to arrows" do
    object = Class.new(Array) { include Crafty::Tools }.new
    content = "foo & bar"
    object.element!("el", content)
    assert_equal ["<el>", "foo &amp; bar",  "</el>"], object
  end

  test "element should return nil if appending to object that responds to arrows" do
    object = Class.new(Array) { include Crafty::Tools }.new
    assert_nil object.element!("el")
  end

  test "element should append html safe strings to object that responds to arrows if html safe exists" do
    begin
      String.class_eval do
        def html_safe
          obj = dup
          class << obj
            def html_safe?; true end
          end
          obj
        end
      end
      object = Class.new(Array) { include Crafty::Tools }.new
      object.element!("el") {
        object.element!("nest") { "content" }
        object.element!("nested") { "more & content" }
      }
      assert_equal [true] * object.length, object.map(&:html_safe?)
    ensure
      String.class_eval do
        undef_method :html_safe
      end
    end
  end

  test "element should append html safe strings to object that responds to arrows if html safe does not exist" do
    object = Class.new(Array) { include Crafty::Tools }.new
    object.element!("el") {
      object.element!("nest") { "content" }
      object.element!("nested") { "more & content" }
    }
    assert_equal [true] * object.length, object.map(&:html_safe?)
  end
end
