class Object
  def html_safe?
    false
  end
end

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
        unless (content = yield.to_s) == @artisan_output
          if content.html_safe?
            @artisan_output << content
          else
            @artisan_output << Elements.escape(content)
          end
        end
        @artisan_output << "</#{element}>"
      else
        @artisan_output << "<#{element}#{Elements.format_attributes(attributes)}/>"
      end
      @artisan_output
    end
  end
end
