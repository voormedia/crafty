require File.expand_path("../test_helper", File.dirname(__FILE__))

class HTML5Test < Test::Unit::TestCase
  def setup
    @object = Class.new { include Artisan::HTML5 }.new
  end

  # Simple methods ===========================================================
  test "html should equal html5" do
    assert_equal Artisan::HTML, Artisan::HTML5
  end

  test "div should return content with given attributes" do
    assert_equal %Q{<div class="green">Hello</div>}, @object.div(:class => "green") { "Hello" }
  end

  test "div should return closing tag without content" do
    assert_equal %Q{<div class="green"></div>}, @object.div(:class => "green")
  end

  test "a should return anchor with given attributes" do
    assert_equal %Q{<a href="http://example.org">link</a>}, @object.a("link", :href => "http://example.org")
  end

  test "title should return title with content" do
    assert_equal %Q{<title>Hello</title>}, @object.title("Hello")
  end

  # Examples =================================================================
  test "complex nested build calls should render correctly" do
    assert_equal %Q{<html>} +
      %Q{<head><title>my document</title><link href="style.css" rel="stylesheet" type="text/css"/></head>} +
      %Q{<body class="awesome"><div><div><table cellspacing="0">} +
      %Q{<tr><th>Col 1</th><th>Col 2</th></tr>} +
      %Q{<tr><td>10000</td><td>content</td></tr>} +
      %Q{</table></div></div></body>} +
      %Q{</html>}, @object.instance_eval {
      html do
        head do
          title { "my document" }
          link :href => "style.css", :rel => :stylesheet, :type => "text/css"
        end
        body :class => :awesome do
          div {
            div {
              table :cellspacing => 0 do
                tr {
                  th { "Col 1" }
                  th { "Col 2" }
                }
                tr {
                  td { 10_000 }
                  td { "content" }
                }
              end
            }
          }
        end
      end
    }
  end
end
