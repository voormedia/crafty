module Crafty
  # Builder provides a builder-like class to construct HTML output. You can
  # use builders if you don't want to include the helper modules in your
  # own builder class. You can also subclass from the Builder class to easily
  # create your own builders.
  class Builder
    class << self
      def build
        builder = new
        yield builder
        builder.to_s
      end
    end
    
    attr_reader :target

    def initialize(target = "")
      @target = target
    end

    def to_s
      @target.to_s
    end

    def <<(output)
      @target << output
    end
  end
end
