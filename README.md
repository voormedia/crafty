Crafty – handcrafted HTML in pure Ruby
======================================

Crafty allows you to easily and flexibly craft HTML output with pure Ruby
code. It is inspired by Builder and Markaby, but is simpler and more flexible.
Its goal is to provide simple helpers that allow you to build HTML markup in
any class.

Crafty can be used in builder classes that construct complex HTML markup, such
as form builders or pagination builders. Whenever you need to programmatically
construct HTML, consider including a Crafty helper module.


Features
--------

* Crafty is simple and fast.

* HTML element sets are predefined and provided as mix-ins.

* Automatic HTML output escaping, 100% compatible with Rails.

* No `instance_eval` or `method_missing` tricks, just helper methods.


Synopsis
--------

    require "crafty"

    class Widget
      include Crafty::HTML::Basic

      def initialize(target)
        @target = target
      end

      def render
        html do
          head do
            title "Hello"
          end
          body do
            render_content
          end
        end
      end

      def render_content
        div class: "main" do
          p "Hello, #{@target}!"
        end
      end
    end

    Widget.new("world").render
    #=> "<html><head><title>Hello</title></head><body><div class=\"main\"><p>Hello, world!</p></div></body></html>"


Helper modules
--------------

You can choose from one of the following helper modules:

* `Crafty::HTML::Basic`: A simple subset of all HTML elements, enough
  for most HTML layouts.

* `Crafty::HTML::Forms`: All HTML elements that are related to forms. If you
  use Rails, note that the names of some of these elements conflict with Rails
  helpers (such as `label` and `input`).

* `Crafty::HTML::Semantic`: Juicy new HTML5 elements such as `header`,
  `footer`, `nav`, etc.

* `Crafty::HTML::All`: All HTML5 elements that are defined in the HTML5 draft
  spec. If you use Rails, note that some elements might conflict with Rails
  helpers.

You can also choose to use `Crafty::HTML4::Basic`, `Crafty::HTML4::Forms` and
`Crafty::HTML4::All` instead. These modules provide helpers for HTML4/XHTML
elements.


Output streaming
----------------

Crafty helpers return strings by default. However, if the object you use the
helpers in responds to `<<`, Crafty will push any output directly onto the
current object. This allows you to create builder classes that can stream
output. Observe how it works with this contrived example:

    class StreamingWidget < Array   # Subclass Array to demonstrate '<<'
      include Crafty::HTML::Basic

      def render(target)
        html do
          head do
            title %Q(Hello "#{target}")
          end
        end
      end
    end

    widget = StreamingWidget.new
    widget.render("world")
    #=> nil
    widget
    #=> ["<html>", "<head>", "<title>", "Hello &quot;world&quot;", "</title>", "</head>", "</html>"]


Benchmarks
----------

Benchmarks do not necessarily give a complete picture of real-world
performance. Nevertheless, we wish to demonstrate that Crafty is fast enough
for daily use. These benchmarks were performed with Ruby 1.9.2.

    Number of iterations = 50000
                              user     system      total        real
    crafty                7.630000   0.140000   7.770000 (  7.750502)
    builder              17.420000   0.110000  17.530000 ( 17.513536)
    haml                 17.450000   0.180000  17.630000 ( 17.600038)
    erector              15.400000   0.110000  15.510000 ( 15.491134)
    tagz                 32.860000   0.650000  33.510000 ( 33.461828)
    nokogiri             27.450000   0.210000  27.660000 ( 27.608287)


Requirements
------------

Crafty has no requirements other than Ruby (tested with 1.8.7+).


Installation
------------

Install as a gem:

    gem install crafty

Or add to your project's `Gemfile`:

    gem "crafty"


About Crafty
-------------

Crafty was created by Rolf Timmermans (r.timmermans *at* voormedia.com)

Copyright 2010-2011 Voormedia - [www.voormedia.com](http://www.voormedia.com/)


License
-------

Crafty is released under the MIT license.

