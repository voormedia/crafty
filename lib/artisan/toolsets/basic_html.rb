module Artisan
  basic_elements = %w{body div em h1 h2 h3 h4 h5 h6 head html il nav p pre
  small span strong sub summary sup table td th tr ul}

  basic_empty_elements = %w{br}

  BasicHTML = Toolset.create(basic_elements, basic_empty_elements)
end
