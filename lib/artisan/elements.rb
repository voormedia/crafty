require "artisan/safety"

module Artisan
  module Elements
    ESCAPE_SEQUENCE = { "&" => "&amp;", ">" => "&gt;", "<" => "&lt;", '"' => "&quot;" }

    class << self
      def format_attributes(attributes)
        return if attributes.nil?
        output = ""
        attributes.each do |name, value|
          output << %Q{ #{name}="#{escape!(value)}"}
        end
        output
      end

      def escape(content)
        if content.html_safe? then content else escape!(content) end
      end

      def escape!(content)
        content.gsub(/[&><"]/) { |char| ESCAPE_SEQUENCE[char] }
      end
    end

    def element!(element, attributes = {})
      @artisan_output ||= SafeString.new
      if block_given?
        @artisan_output << "<#{element}#{Elements.format_attributes(attributes)}>"
        unless (content = yield.to_s) == @artisan_output
          @artisan_output << Elements.escape(content)
        end
        @artisan_output << "</#{element}>"
      else
        @artisan_output << "<#{element}#{Elements.format_attributes(attributes)}/>"
      end
      @artisan_output
    end
  end
end
