# Implements a really dump value 2 value parser DSL

class DumpParser

  def initialize(name,map=nil,block=nil)
    @name,@map,@block = name,map,block
  end

  class << self

    def register(name,map=nil,&block)
      parser = self.new(name,map,block)
      registry[name]=parser
      self
    end

    def has_parser?(name)
      registry.key? name
    end

    def [](name)
      registry[name]
    end

    def reset!
      @registry = nil
    end

    def names
      registry.keys
    end

    protected

    def registry
      @registry ||= {}
    end
  end
end
