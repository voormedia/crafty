module Artisan
  module Toolset
    class << self
      def create(elements = [], empty_elements = [])
        Module.new do
          def self.append_features(mod)
            redefined = mod.instance_methods & self.instance_methods(false)
            if redefined.any?
              dup.tap do |safe|
                redefined.each do |method|
                  safe.send :remove_method, method
                end
              end.append_features(mod)
            else
              super
            end
          end

          include Elements

          elements.each do |element|
            module_eval <<-RUBY, __FILE__, __LINE__ + 1
              def #{element}(*arguments, &block)
                arguments.unshift("") if !arguments.first.kind_of?(String) && !block
                element!("#{element}", *arguments, &block)
              end
            RUBY
          end

          empty_elements.each do |element|
            module_eval <<-RUBY, __FILE__, __LINE__ + 1
              def #{element}(attributes = nil)
                element!("#{element}", attributes)
              end
            RUBY
          end
        end
      end
    end
  end
end
