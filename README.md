Artisan – build HTML like a craftsman
=====================================

Artisan allows you to easily and flexibly craft HTML output. It is inspired
by Builder and Markaby, but is simpler and more flexible. Its goal is to
provide simple helpers that allow you to build HTML markup in any class.

Synopsis
--------

    require "artisan"

    class Widget
      include Artisan::HTML

      def initialize(target)
        @target = target
      end

      def render
        html do
          head do
            title { "Hello" }
          end
          body do
            render_content
          end
        end
      end

      def render_content
        div class: "main" do
          p { "Hello, #{@target}!" }
        end
      end
    end

    Widget.new("world").render
    #=> "<html><head><title>Hello</title></head><body><div class=\"main\"><p>Hello, world!</p></div></body></html>"

Requirements
------------

Artisan has no requirements other than Ruby (tested with 1.8.7+).

Installation
------------

    gem install artisan

About Artisan
-------------

Artisan was created by Rolf Timmermans (r.timmermans *at* voormedia.com)

Copyright 2010-2011 Voormedia - [www.voormedia.com](http://www.voormedia.com/)


License
-------

Artisan is released under the MIT license.

