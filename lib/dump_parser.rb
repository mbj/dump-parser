# Parser registration and library namespace
class DumpParser
  # Error raised when parser was feed with an invalid value
  class ParseError < RuntimeError; end

  #Undefined object
  Undefined = Object.new.freeze

  DEFAULT_BLOCK = proc { fetch_map }.freeze

  # Return name of parser
  #
  # @return [Symbol] 
  #
  # @api private
  #
  attr_reader :name

  # Return input output map
  #
  # @return [Hash] 
  #
  # @api private
  #
  attr_reader :map

  # Return processing block
  #
  # @return [Proc] 
  #
  # @api private
  #
  attr_reader :block

  # Initialize a dump parser
  #
  # @param [Symbol] name
  #   the name of the parser
  # @param [Hash] map
  #   the map of inputs to outputs
  # @param [Proc] block
  #   the block to execute
  #
  # @return [undefined]
  #
  # @api private
  #
  def initialize(name, map=nil, block=nil)
    unless block || map
      raise ArgumentError,'need map block or both'
    end

    block ||= DEFAULT_BLOCK

    @name,@map,@block = name,map,block

    freeze
  end

  # Execute parser on value
  #
  # @param [String] value
  #
  # @return [Object]
  #
  # @api private
  #
  def execute(value)
    unless value.kind_of?(String)
      raise ParseError.new("#{name}: #{value.inspect} must be kind of String")
    end
    Executor.new(self,value).result
  end

  # Execute parser with name and value
  #
  # @param [String] name
  # @param [String] value
  #
  # @return [Object]
  #
  # @api private
  #
  def self.execute(name,value)
    lookup(name).execute(value)
  end

  # Register parser
  #
  # @param [String|Symbol] name
  #   the name of the parser to register
  # @param [Hash] map
  #   a input to output map
  # @yield 
  #   the block to execute on parsing.
  #   Defaults to fetch from map.
  #
  # @return [self]
  #
  # @raise [ArgumentError]
  #   raises an argument error if parser with same name is
  #   already registred.
  #
  # @example
  #   
  #   DumpParser.register(:ugly_format) do
  #     require_format %r(\Afoo(\d+)\z)
  #     match[1].to_i(10)
  #   end
  #
  # @api public
  #
  def self.register(name,map=nil,&block)
    name = name.to_s
    if present?(name)
      raise ArgumentError,"a parser named #{name.inspect} is already registred"
    end
    parser = new(name,map,block)
    registry[name]=parser

    self
  end

  # Return a parser with name
  #
  # @param [String|Symbol] name
  #
  # @return [DumpParser]
  #
  # @raise [ArgumentError]
  #   raises an argument error if parser with name cannot be found
  #
  # @api private
  #
  def self.lookup(name)
    name = name.to_s
    registry.fetch(name) do
      raise ArgumentError,"a parser named #{name.inspect} is not registred"
    end
  end

  # Check if a parser with is present
  #
  # @param [String|Symbol] name
  #
  # @return [true]
  #   returns true if parser is present
  # @return [false]
  #   returns false if parser is NOT present
  #
  # @api private
  #
  def self.present?(name)
    registry.key?(name.to_s)
  end

  # Reset all parsers
  #
  # @return [self]
  #
  # @api private
  #
  def self.reset
    registry.clear
    self
  end

  # Return all parser names
  #
  # @return [Array<String>]
  #
  # @api private
  #
  def self.names
    registry.keys
  end

  # Return registry for parsers
  #
  # @return [Hash]
  #
  # @api private
  #
  def self.registry
    REGISTRIES[self] ||= {}
  end
  private_class_method :registry

  REGISTRIES = {}
end

require 'dump_parser/executor'
