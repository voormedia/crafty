require File.expand_path("../test_helper", File.dirname(__FILE__))

class BuilderTest < Test::Unit::TestCase
  def setup
    @builder = Class.new(Crafty::Builder) { include Crafty::HTML::All }.new
  end

  # Basic builder functionality ==============================================
  test "element should build element with given name" do
    @builder.element!("el")
    assert_equal %Q{<el/>}, @builder.to_s
  end

  test "target should return given target with appended content" do
    @builder.element!("el")
    assert_equal %Q{<el/>}, @builder.target
  end

  test "div should build content with given attributes" do
    @builder.div("Hello", :class => "green")
    assert_equal %Q{<div class="green">Hello</div>}, @builder.to_s
  end

  # Examples ===============================================================
  test "complex nested build calls should build correctly" do
    b = @builder
    b.html do
      b.head do
        b.title "my document"
        b.link :href => "style.css", :rel => :stylesheet, :type => "text/css"
      end
      b.body :class => :awesome do
        b.div {
          b.div {
            b.table :cellspacing => 0 do
              b.tr {
                b.th "Col 1"
                b.th "Col 2"
              }
              b.tr {
                b.td 10_000
                b.td "content"
              }
            end
          }
        }
      end
    end
    assert_equal %Q{<html>} +
      %Q{<head><title>my document</title><link href="style.css" rel="stylesheet" type="text/css"/></head>} +
      %Q{<body class="awesome"><div><div><table cellspacing="0">} +
      %Q{<tr><th>Col 1</th><th>Col 2</th></tr>} +
      %Q{<tr><td>10000</td><td>content</td></tr>} +
      %Q{</table></div></div></body>} +
      %Q{</html>}, @builder.to_s
  end
end
