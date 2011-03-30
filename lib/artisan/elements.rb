require "artisan/safety"

module Artisan
  module Elements
    ESCAPE_SEQUENCE = { "&" => "&amp;", ">" => "&gt;", "<" => "&lt;", '"' => "&quot;" }

    class << self
      def format_attributes(attributes)
        return if attributes.nil?
        output = ""
        attributes.each do |name, value|
          output << %Q{ #{name}="#{escape(value.to_s)}"}
        end
        output
      end

      def escape(content)
        return content if content.html_safe?
        content.gsub(/[&><"]/) { |char| ESCAPE_SEQUENCE[char] }
      end
    end

    def element!(element, attributes = {})
      ensure_building! do
        if block_given?
          @artisan_output << "<#{element}#{Elements.format_attributes(attributes)}>"
          unless (content = yield) == @artisan_output
            @artisan_output << Elements.escape(content.to_s)
          end
          @artisan_output << "</#{element}>"
        else
          @artisan_output << "<#{element}#{Elements.format_attributes(attributes)}/>"
        end
      end
    end

    def comment!(content)
      ensure_building! do
        @artisan_output << "<!-- "
        @artisan_output << Elements.escape(content.to_s)
        @artisan_output << " -->"
      end
    end

    def instruct!(name = nil, attributes = {})
      unless name
        name = "xml"
        attributes = { :version => "1.0", :encoding => "UTF-8" }
      end
      ensure_building! do
        @artisan_output << "<?#{name}#{Elements.format_attributes(attributes)}?>"
      end
    end

    def write!(content)
      ensure_building! do
        @artisan_output << content
      end
    end

    private

    def ensure_building!
      previous_builder, @artisan_output = @artisan_output, @artisan_output || (respond_to?(:<<) ? self : SafeString.new)
      yield
      @artisan_output
    ensure
      @artisan_output = previous_builder
    end
  end
end
