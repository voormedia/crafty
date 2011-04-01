$: << File.expand_path("../../lib", __FILE__)
require "crafty"

class Cr
  include Crafty::HTML::Basic

  def render(url)
    html do
      head do
        title "happy title"
      end

      body do
        h1 "happy heading"
        10.times do
          a "a link", :href => url
        end
      end
    end
  end
end

def crafty_simple(url)
  Cr.new.render(url)
end
