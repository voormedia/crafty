module Crafty
  module Toolset
    class << self
      def define(mod, elements = [], empty_elements = [])
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

        elements.each do |element|
          mod.module_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{element}(*arguments, &block)
              attributes = arguments.pop if arguments.last.kind_of? Hash
              content = arguments.first || ""
              element!("#{element}", content, attributes, &block)
            end
          RUBY
        end

        empty_elements.each do |element|
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
