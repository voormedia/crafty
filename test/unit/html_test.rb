require File.expand_path("../test_helper", File.dirname(__FILE__))

class HTMLBase < Test::Unit::TestCase
  def self.behaves_as_basic_html
    # Simple methods ===========================================================
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

    test "h1 should return h1 header" do
      assert_equal %Q{<h1>Title</h1>}, @object.h1 { "Title" }
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
end

class HTML5Test < HTMLBase
  def setup
    @object = Class.new { include Crafty::HTML5::Basic }.new
  end

  behaves_as_basic_html
end

class HTML4Test < HTMLBase
  def setup
    @object = Class.new { include Crafty::HTML4::Basic }.new
  end

  behaves_as_basic_html
end

class HTMLAliasTest < Test::Unit::TestCase
  test "html should equal html5" do
    assert_equal Crafty::HTML, Crafty::HTML5
  end

  test "xhtml should equal html4" do
    assert_equal Crafty::XHTML, Crafty::HTML4
  end
end
