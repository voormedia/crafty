$: << File.expand_path("../../lib", __FILE__)
require "crafty"

class CrBuilder
  include Crafty::HTML::Basic
end

def crafty_builder_simple(url)
  cr = CrBuilder.new
  cr.html do
    cr.head do
      cr.title "happy title"
    end

    cr.body do
      cr.h1 "happy heading"
      10.times do
        cr.a "a link", :href => url
      end
    end
  end
end
