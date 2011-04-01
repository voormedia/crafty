require "builder"

def builder_simple(url)
  Builder::XmlMarkup.new.html { |xm|
    xm.head {
      xm.title "happy title"
    }
    xm.body {
      xm.h1 "happy heading"
      10.times do
        xm.a "a link", :href => url
      end
    }
  }
end
