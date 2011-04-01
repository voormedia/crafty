require "haml"

@haml_obj = Object.new

haml = <<-EOF
%html
  %head
    %title happy title
  %body
    %h1 happy heading
    - 10.times do
      %a{:href => url} a link
EOF
Haml::Engine.new(haml, :ugly => true).def_method(@haml_obj, :haml, :url)

def haml_simple(url)
  @haml_obj.haml(:url => url)
end
