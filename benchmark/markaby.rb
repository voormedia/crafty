module Markaby
  class Fragment < ::Builder::BlankSlate
    def to_s; end
    def inspect; end
    def ==; end
  end
end
require "markaby"

Markaby::Builder.set :output_meta_tag, false

def markaby_simple(url)
  mab = Markaby::Builder.new

  mab.html {
    head {
      title "happy title"
    }
    body {
      h1 "happy heading"
      10.times do
        a "a link", :href => url
      end
    }
  }.to_s
end
