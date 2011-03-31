module Crafty
  # This toolset has been automatically generated.
  module HTML5
    module Basic
      Toolset.define(self, %w{a blockquote body div em h1 h2 h3 h4 h5 h6 head
      html li p pre small span strong table td th title tr ul}, %w{br img
      link})
    end

    module Forms
      Toolset.define(self, %w{button datalist fieldset form label meter object
      option output progress select textarea}, %w{input keygen})
    end

    module Semantic
      Toolset.define(self, %w{abbr address article cite code details figcaption
      figure footer header legend menu nav section}, %w{command})
    end

    module All
      Toolset.define(self, %w{a abbr address article aside audio b bdi bdo
      blockquote body button canvas caption cite code colgroup datalist dd del
      details dfn div dl dt em fieldset figcaption figure footer form h1 h2 h3
      h4 h5 h6 head header hgroup html i iframe ins kbd label legend li map
      mark menu meter nav noscript object ol optgroup option output p pre
      progress q rp rt ruby s samp script section select small span strong
      style sub summary sup table tbody td textarea tfoot th thead time title
      tr ul var video}, %w{area base br col command embed hr img input keygen
      link meta param source track wbr})
    end
  end

  HTML = HTML5
end
