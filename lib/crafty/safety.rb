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

    def to_s
      self
    end
  end
end
