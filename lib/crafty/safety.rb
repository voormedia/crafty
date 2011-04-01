class Object
  def html_safe?
    false
  end
end

module Crafty
  class SafeString < String
    def html_safe?
      true
    end

    def html_safe
      self
    end

    alias_method :to_s, :html_safe
    alias_method :render, :html_safe
  end

  class SafeWrapper
    def initialize(base)
      @base = base
    end

    def <<(data)
      @base << SafeString.new(data)
    end

    def render
      nil
    end
  end
end
