module Crafty
  # This toolset has been automatically generated.
  module HTML4
    module Basic
      Toolset.define(self, %w{a blockquote body div em h1 h2 h3 h4 h5 h6 head
      html li p pre small span strong table td th title tr ul}, %w{br img
      link})
    end

    module Forms
      Toolset.define(self, %w{button fieldset form label object option select
      textarea}, %w{input})
    end

    module Semantic
      Toolset.define(self, %w{abbr acronym address cite code legend menu})
    end

    module All
      Toolset.define(self, %w{a abbr acronym address applet b bdo big
      blockquote body button caption center cite code colgroup dd del dfn dir
      div dl dt em fieldset font form frameset h1 h2 h3 h4 h5 h6 head html i
      iframe ins kbd label legend li map menu noframes noscript object ol
      optgroup option p pre q s samp script select small span strike strong
      style sub sup table tbody td textarea tfoot th thead title tr tt u ul
      var}, %w{area base basefont br col frame hr img input isindex link meta
      param})
    end
  end

  XHTML = HTML4
end
