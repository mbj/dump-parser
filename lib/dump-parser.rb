# Implements a really dump value 2 value parser DSL
class DumpParser
  class ParseError < RuntimeError; end

  DEFAULT_MAP_BLOCK = Proc.new { fetch_map }

  attr_reader :name

  def initialize(name,map=nil,block=nil)
    if map
      block ||= DEFAULT_MAP_BLOCK
    end

    unless block || map
      raise ArgumentError,'need map block or both'
    end

    @name,@map,@block = name,map,block
  end

  def execute(value)
    @value = value
    begin
      catch :done do
        @result = instance_eval(&@block)
      end
      returning @result do
        @result = nil
      end
    ensure
      reset!
    end
  end

  private

  attr_reader :value

  def reset!
    @value = @result = @match = nil
  end

  def map
    @map || raise(RuntimeError,'this parser does not have a map')
  end

  def returning(value)
    yield
    value
  end

  def fetch_map
    unless map.key? value
      parse_error('is not valid')
    else
      map.fetch value
    end
  end

  def parse_error(message)
    raise ParseError.new("#{name}: value #{value.inspect} #{message}")
  end

  class << self

    def register(name,map=nil,&block)
      if has_parser? name
        raise ArgumentError,"a parser named #{name.inspect} is already registred"
      end
      parser = self.new(name,map,block)
      registry[name]=parser
    end

    def lookup(name)
      registry[name] || raise(ArgumentError,"a parser named #{name.inspect} is not registred")
    end

    alias :[] :lookup

    def has_parser?(name)
      registry.key? name
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
