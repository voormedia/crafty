# Crafty provides a set of modules that provide helper methods to create
# various HTML elements.
module Crafty
  autoload :Tools, "crafty/tools"
  autoload :Toolset, "crafty/toolset"

  autoload :HTML5, "crafty/toolsets/html5"
  autoload :HTML4, "crafty/toolsets/html4"

  autoload :HTML,  "crafty/toolsets/html5"
  autoload :XHTML, "crafty/toolsets/html4"
end
