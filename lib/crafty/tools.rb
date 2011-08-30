require "crafty/safety"

module Crafty
  module Tools
    class << self
      ESCAPE_SEQUENCE = { "&" => "&amp;", ">" => "&gt;", "<" => "&lt;", '"' => "&quot;" }

      # Escape HTML/XML unsafe characters.
      def escape(content)
        return content if content.html_safe?
        content.gsub(/[&><"]/) { |char| ESCAPE_SEQUENCE[char] }
      end

      # Formats the given hash of attributes into a string that can be used
      # directly inside an HTML/XML tag.
      def format_attributes(attributes)
        return if attributes.nil?
        attributes.collect do |name, value|
          value = if value.kind_of? Array
            value.flatten.compact * " "
          else
            value.to_s
          end
          next if value == ""
          %Q{ #{name}="#{escape(value)}"}
        end.join
      end

      # Formats the given array of parameters into a string that can be used
      # directly inside an HTML/XML (entity) declaration.
      def format_parameters(parameters)
        return if parameters.nil?
        parameters.collect do |name|
          name = name.inspect if name.kind_of? String
          %Q{ #{name}}
        end.join
      end

      # Creates a safe string buffer or wraps the given object in an object
      # that acts like a safe string buffer.
      def create_stream(base)
        if base.respond_to? :<<
          SafeWrapper.new(base)
        else
          SafeString.new
        end
      end
    end

    # Write an element with the given name, content and attributes. If
    # there is no content and no block is given, a self-closing element is
    # created. Provide an empty string as content to create an empty,
    # non-self-closing element.
    def element!(name, content = nil, attributes = nil)
      build! do
        if content or block_given?
          @_crafted << "<#{name}#{Tools.format_attributes(attributes)}>"
          if block_given?
            value = yield
            content = value if !@_appended or value.kind_of? String
          end

          content = content.respond_to?(:empty?) && content.empty? ? '' : content.to_s

          @_crafted << Tools.escape(content) if content != ""
          @_crafted << "</#{name}>"
        else
          @_crafted << "<#{name}#{Tools.format_attributes(attributes)}/>"
        end
      end
    end

    # Write a comment with the given content.
    def comment!(content)
      build! do
        @_crafted << "<!-- "
        @_crafted << Tools.escape(content.to_s)
        @_crafted << " -->"
      end
    end

    # Write a processing instruction with the given name and attributes.
    # Without arguments, it creates a default xml processing instruction.
    def instruct!(name = nil, attributes = {})
      unless name
        name = "xml"
        attributes = { :version => "1.0", :encoding => "UTF-8" }
      end
      build! do
        @_crafted << "<?#{name}#{Tools.format_attributes(attributes)}?>"
      end
    end

    # Write a (doctype or entity) declaration with the given name and
    # parameters.
    def declare!(name, *parameters)
      build! do
        @_crafted << "<!#{name}#{Tools.format_parameters(parameters)}>"
      end
    end

    # Write the given text, escaping it if necessary.
    def text!(content)
      build! do
        @_crafted << Tools.escape(content.to_s)
      end
    end
    alias_method :write!, :text!

    # Collects all elements built inside the given block into a single string.
    def build!
      @_appended = false
      if @_crafted
        yield
        @_appended = true
        nil
      else
        begin
          @_crafted = Tools.create_stream(self)
          yield
          @_crafted.render
        ensure
          @_crafted = nil
        end
      end
    end
  end
end
