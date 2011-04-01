require "erubis"

@erubis_obj = Object.new

eruby = <<-EOF
<html>
  <head>
    <title>happy title</title>
  </head>
  <body>
    <h1>happy heading</h1>
    <% 10.times do %>
    <a href="<%= url %>">a link</a>
    <% end %>
  </body>
</html>
EOF
eruby.smush!
Erubis::Eruby.new(eruby).def_method(@erubis_obj, "erubis(url)")

def erubis_simple(url)
  @erubis_obj.erubis(url)
end
