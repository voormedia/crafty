require "tagz"

def tagz_simple(url)
  Tagz {
    html_ {
      head_ {
        title_ "happy title"
      }
      body_ {
        h1_ "happy heading"
        10.times do
          a_ "a link", :href => url
        end
      }
    }
  }
end
