module Artisan
  # Source: http://dev.w3.org/html5/spec/Overview.html#elements-1
  html5_elements = %w{a abbr address article aside audio b bdi bdo blockquote
  body button canvas caption cite code colgroup datalist dd del details dfn
  div dl dt em fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head
  header hgroup html i iframe ins kbd label legend li map mark menu meter nav
  noscript object ol optgroup option output p pre progress q rp rt ruby s samp
  script section select small span strong style sub summary sup table tbody td
  textarea tfoot th thead time title tr ul var video}

  html5_empty_elements = %w{area base br col command embed hr img input keygen
  link meta param source track wbr}

  HTML5 = Toolset.create(html5_elements, html5_empty_elements)
end
