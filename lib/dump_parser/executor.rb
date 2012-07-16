# Implements a really dump value 2 value parser DSL
class DumpParser
  # Parser execution component
  class Executor
    # Return result
    #
    # @return [Object]
    #
    # @api private
    #
    attr_reader :result

    # Return input
    #
    # @return [String]
    #
    # @api private
    #
    attr_reader :input

    # Return a frozen executor
    #
    # @return [Executor]
    #
    # @api private
    #
    def self.new(*)
      super.freeze
    end
 
  private

    # Return current value
    # 
    # @return [Object]
    #
    # @api private
    #
    attr_reader :value
    private :value

    # Return name
    # 
    # @return [String]
    #
    # @api private
    #
    def name
      @parser.name
    end

    # Initialize executor
    #
    # @param [DumpParser] parser
    # @param [String] value
    #
    # @return [undefined]
    #
    # @api private
    #
    def initialize(parser,input)
      @parser, @value, @input = parser, input, input

      catch(:done) do
        @result = instance_eval(&parser.block)
      end
    end

    # Instruct executor to return nil if input is empty
    #
    # @return [nil]
    #   returns nil if input is empty
    #
    # @return [Object]
    #   returns current value if input is NOT empty
    #
    # @example 
    #
    #   DumpParser.register(:can_be_empty) do
    #     nil_if_empty
    #     :value
    #   end
    #
    #   DumpParser.execute(:can_be_empty,'') # => nil
    #   DumpParser.execute(:can_be_empty,'1') # => :value
    #
    # @api private
    #
    def nil_if_empty
      if empty? 
        @result = nil
        throw :done
      end

      value
    end

    # Instruct parser to fetch key from map
    #
    # Method uses the current value as key for map lookup.
    # The key to fetch can be overriden by paramter.
    #
    # @param [Object] key
    #   if specified uses this key to fetch from map
    #
    # @return [Object]
    #   returns the output value from map
    #
    # @raise [ParseError] 
    #   raises parse error in case key cannot be found.
    #
    # @api private
    #
    def fetch_map(key=Undefined)
      key = value if key == Undefined

      map.fetch(key) do 
        parse_error('is not valid')
      end
    end

    # Instruct executor to raise an error if input is empty
    #
    # @return [Object]
    #   returns current value if input is NOT empty
    #
    # @raise [ParseError] 
    #   raises a parse error in case input is empty
    #
    # @example 
    #
    #   DumpParser.register(:cannot_be_empty) do
    #     error_if_empty
    #     :value
    #   end
    #
    #   DumpParser.execute(:cannot_be_empty,'') # => raises ParseError
    #   DumpParser.execute(:cannot_be_empty,'1') # => :value
    #
    # @api private
    #
    def error_if_empty
      if empty?
        parse_error('must not be empty')
      end

      value
    end

    # Instruct executor to require input format
    #
    # In case input is in required format the match 
    # is accessible via #match
    #
    # @param [Regexp] format
    #   the format the input must have
    #
    # @raise [ParseError]
    #   raises a parse error if input is not in required format
    #
    # @return [Object]
    #   returns the current value
    #
    # @api private
    #
    # @example
    #
    #   DumpParser.register(:ugly_format) do
    #     require_format %r(\Afoo(\d+)\z)
    #     match[1].to_i(10)
    #   end
    #
    #   DumpParser.execute(:ugly_format,"foo100") # => 100
    #   DumpParser.execute(:ugly_format,"foo1")   # raises ParseError
    #
    # @api private
    #
    def require_format(format)
      current_value = value
      @last_match = format.match(current_value)

      unless @last_match
        parse_error('does not match required format')
      end

      current_value
    end

    # Return last match
    #
    # @raise [RuntimeError] 
    #   raises runtime error in case there was no match stored before
    #
    # @return [MatchData]
    #   returns match data stored from last match
    #
    # @example
    #
    #   DumpParser.register(:ugly_format) do
    #     require_format %r(\Afoo(\d+)\z)
    #     match[1].to_i(10)
    #   end
    #
    #   DumpParser.execute(:ugly_format,"foo100") # => 100
    #
    # @api private
    #
    def match
      @last_match || parse_error('no current match available')
    end

    # Return map
    #
    # @raise [RuntimeError]
    #   raises runtime error in case parser does not have a map
    #
    # @return [Hash]
    #
    # @api private
    #
    def map
      @parser.map || parse_error('this parser does not have a map')
    end

    # Check if input is empty
    #
    # @return [true]
    #   returns true if input is NOT empty
    #
    # @return [false]
    #   returns false if input is empty
    #
    # @api private
    #
    def empty?
      value.empty?
    end

    # Raise a parse error
    #
    # @param [String] message 
    #   the message the error shold be raised with
    #
    # @return [undefined]
    #
    # @raise [ParseError]
    #   raises a parse error with original input and message
    #
    # @api private
    #
    def parse_error(message)
      raise ParseError.new("#{name}: with input #{@input.inspect} #{message}")
    end
  end
end
