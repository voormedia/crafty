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
          concat! "<#{element}#{Elements.format_attributes(attributes)}>"
          if block_given?
            prev_len = @crafty_output.length
            res = yield
            content = res if @crafty_output.length == prev_len
          end
          concat! Elements.escape(content.to_s) if content
          concat! "</#{element}>"
        else
          concat! "<#{element}#{Elements.format_attributes(attributes)}/>"
        end
      end
    end

    def comment!(content)
      build! do
        concat! "<!-- "
        concat! Elements.escape(content.to_s)
        concat! " -->"
      end
    end

    def instruct!(name = nil, attributes = {})
      unless name
        name = "xml"
        attributes = { :version => "1.0", :encoding => "UTF-8" }
      end
      build! do
        concat! "<?#{name}#{Elements.format_attributes(attributes)}?>"
      end
    end

    def text!(content)
      build! do
        concat! Elements.escape(content.to_s)
      end
    end
    alias_method :write!, :text!

    def build!
      if @crafty_output
        yield
        nil
      else
        begin
          @crafty_output = SafeString.new
          yield
          @crafty_output unless respond_to? :<<
        ensure
          @crafty_output = nil
        end
      end
    end

    def concat!(data)
      if respond_to? :<<
        self << data.html_safe
      else
        @crafty_output << data
      end
    end
  end
end
