module Artisan
  module Elements
    ESCAPE_SEQUENCE = { "&" => "&amp;",  ">" => "&gt;",   "<" => "&lt;", '"' => "&quot;" }

    class << self
      def format_attributes(attributes)
        return if attributes.nil?
        output = ""
        attributes.each do |name, value|
          output << %Q{ #{name}="#{escape(value)}"}
        end
        output
      end

      def escape(content)
        content.gsub(/[&><"]/) { |char| ESCAPE_SEQUENCE[char] }
      end
    end

    def element!(element, attributes = {})
      @artisan_output ||= ""
      if block_given?
        @artisan_output << "<#{element}#{Elements.format_attributes(attributes)}>"
        content = yield
        @artisan_output << Elements.escape(content.to_s) unless content == @artisan_output
        @artisan_output << "</#{element}>"
      else
        @artisan_output << "<#{element}#{Elements.format_attributes(attributes)}/>"
      end
      @artisan_output
    end
  end
end
