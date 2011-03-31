require "crafty/safety"

module Crafty
  module Elements
    ESCAPE_SEQUENCE = { "&" => "&amp;", ">" => "&gt;", "<" => "&lt;", '"' => "&quot;" }

    class << self
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

      def escape(content)
        return content if content.html_safe?
        content.gsub(/[&><"]/) { |char| ESCAPE_SEQUENCE[char] }
      end
    end

    def element!(element, *arguments)
      build! do
        attributes = arguments.pop if arguments.last.kind_of?(Hash)
        content = arguments.first
        if content or block_given?
          @crafty_output << "<#{element}#{Elements.format_attributes(attributes)}>"
          unless (content ||= yield) == @crafty_output
            @crafty_output << Elements.escape(content.to_s)
          end
          @crafty_output << "</#{element}>"
        else
          @crafty_output << "<#{element}#{Elements.format_attributes(attributes)}/>"
        end
      end
    end

    def comment!(content)
      build! do
        @crafty_output << "<!-- "
        @crafty_output << Elements.escape(content.to_s)
        @crafty_output << " -->"
      end
    end

    def instruct!(name = nil, attributes = {})
      unless name
        name = "xml"
        attributes = { :version => "1.0", :encoding => "UTF-8" }
      end
      build! do
        @crafty_output << "<?#{name}#{Elements.format_attributes(attributes)}?>"
      end
    end

    def text!(content)
      build! do
        @crafty_output << Elements.escape(content.to_s)
      end
    end
    alias_method :write!, :text!

    def build!
      if @crafty_output
        yield
      else
        begin
          @crafty_output = SafeString.new
          yield
          if respond_to? :<< then self << @crafty_output else @crafty_output end
        ensure
          @crafty_output = nil
        end
      end
    end
  end
end
