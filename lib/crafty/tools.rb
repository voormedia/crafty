require "crafty/safety"

module Crafty
  module Tools
    class << self
      ESCAPE_SEQUENCE = { "&" => "&amp;", ">" => "&gt;", "<" => "&lt;", '"' => "&quot;" }

      def escape(content)
        return content if content.html_safe?
        content.gsub(/[&><"]/) { |char| ESCAPE_SEQUENCE[char] }
      end

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

      def format_parameters(parameters)
        return if parameters.nil?
        parameters.collect do |name|
          name = name.inspect if name.kind_of? String
          %Q{ #{name}}
        end.join
      end

      def create_stream(base)
        if base.respond_to? :<<
          SafeWrapper.new(base)
        else
          SafeString.new
        end
      end
    end

    def element!(name, content = nil, attributes = nil)
      build! do
        if content or block_given?
          @_crafted << "<#{name}#{Tools.format_attributes(attributes)}>"
          if block_given?
            value = yield
            content = value if !@_appended or value.kind_of? String
          end
          @_crafted << Tools.escape(content.to_s) if content
          @_crafted << "</#{name}>"
        else
          @_crafted << "<#{name}#{Tools.format_attributes(attributes)}/>"
        end
      end
    end

    def comment!(content)
      build! do
        @_crafted << "<!-- "
        @_crafted << Tools.escape(content.to_s)
        @_crafted << " -->"
      end
    end

    def instruct!(name = nil, attributes = {})
      unless name
        name = "xml"
        attributes = { :version => "1.0", :encoding => "UTF-8" }
      end
      build! do
        @_crafted << "<?#{name}#{Tools.format_attributes(attributes)}?>"
      end
    end

    def declare!(name, *parameters)
      build! do
        @_crafted << "<!#{name}#{Tools.format_parameters(parameters)}>"
      end
    end

    def text!(content)
      build! do
        @_crafted << Tools.escape(content.to_s)
      end
    end
    alias_method :write!, :text!

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
