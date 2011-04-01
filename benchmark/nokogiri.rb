require "nokogiri"

def nokogiri_simple(url)
  html = Nokogiri do
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

  html.to_s
end
