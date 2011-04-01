require "erector"

class Happy < Erector::Widget
  def content
    html {
      head {
        title "happy title"
      }
      body {
        h1 "happy heading"
        10.times do
          a "a link", :href => @url
        end
      }
    }
  end
end

def erector_simple(url)
  Happy.new(:url => url).to_html
end
