# This file contains canonical sources of element lists, which are combined
# to generate Ruby modules. We generate the code because it makes it easier
# to maintain the lists of elements, without having to maintain duplicate
# information. Additionally, we can apply additional logic to this information
# when generating the element lists.

# Available HTML versions.
Versions = [:HTML4, :HTML5]

# http://www.w3.org/TR/1999/REC-html401-19991224/index/elements.html
HTML4 = %w{a abbr acronym address applet area b base basefont bdo big
blockquote body br button caption center cite code col colgroup dd del dfn dir
div dl dt em fieldset font form frame frameset h1 h2 h3 h4 h5 h6 head hr html
i iframe img input ins isindex kbd label legend li link map menu meta noframes
noscript object ol optgroup option p param pre q s samp script select small
span strike strong style sub sup table tbody td textarea tfoot th thead title
tr tt u ul var}

# http://dev.w3.org/html5/spec/Overview.html#elements-1
HTML5 = %w{a abbr address area article aside audio b base bdi bdo blockquote
body br button canvas caption cite code col colgroup command datalist dd del
details dfn div dl dt em embed fieldset figcaption figure footer form h1 h2 h3
h4 h5 h6 head header hgroup hr html i iframe img input ins kbd keygen label
legend li link map mark menu meta meter nav noscript object ol optgroup option
output p param pre progress q rp rt ruby s samp script section select small
source span strong style sub summary sup table tbody td textarea tfoot th
thead time title tr track ul var video wbr}

# Self closing tags?
Childless = %w{area base basefont br col command embed frame hr img input
isindex keygen link meta param source track wbr}

# Sets can be independently included.
Sets = [:Basic, :Forms, :Semantic]

Basic = %w{a blockquote body br div em h1 h2 h3 h4 h5 h6 head html img li p
pre small span strong table td th title tr ul} + %w{link} # Last ones are dubious

Forms = %w{button datalist fieldset form input keygen label meter object
option output progress select textarea}

Semantic = %w{abbr acronym address article cite code command details
figcaption figure footer header legend menu nav section}
