module Crafty
  module Toolset
    class << self
      # Define the given elements and self-closing elements in the given
      # module. The module will be modified to never overwrite existing
      # methods, even if they have been defined in superclasses or other
      # previously-included modules.
      def define(mod, elements = [], empty_elements = [])
        define_elements(mod, elements)
        define_empty_elements(mod, empty_elements)

        mod.module_eval do
          include Tools

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
        end
      end

      # Define regular elements in the given module.
      def define_elements(mod, elements)
        elements.each do |element|
          mod.module_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{element}(*arguments, &block)
              attributes = arguments.pop if arguments.last.kind_of? Hash
              content = arguments.first || ""
              element!("#{element}", content, attributes, &block)
            end
          RUBY
        end
      end

      # Define empty, self-closing elements in the given module.
      def define_empty_elements(mod, elements)
        elements.each do |element|
          mod.module_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{element}(attributes = nil)
              element!("#{element}", nil, attributes)
            end
          RUBY
        end
      end
    end
  end
end
