# Implements a really dump value 2 value parser DSL
class DumpParser
  # Error raised when parser was feed with an invalid value
  class ParseError < RuntimeError; end

  DEFAULT_MAP_BLOCK = Proc.new { fetch_map }

  attr_reader :name

  def initialize(name,map=nil,block=nil)
    unless block || map
      raise ArgumentError,'need map block or both'
    end

    block ||= DEFAULT_MAP_BLOCK

    @name,@map,@block = name,map,block
  end

  def execute(value)
    unless value.kind_of? String
      raise '+value+ must be kind of String'
    end
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

  protected

  attr_reader :value

  protected :value

  def nil_if_empty
    value = self.value
    if value.empty? 
      @result = nil
      throw :done
    else
      value
    end
  end

  def require_format(format)
    value = self.value
    @last_match = format.match value
    if @last_match
      value
    else
      parse_error 'does not match required format'
    end
  end

  def match
    @last_match || raise(RuntimeError,'no current match available')
  end

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
    map,value = self.map,self.value
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

    def execute(name,value)
      parser = lookup name
      parser.execute(value)
    end

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
