require 'spec_helper'

describe DumpParser do
  before :all do
    DumpParser.register :simple_map, {
      'a' => 'A',
      'b' => 'B',
      'c' => 'C'
    }

    DumpParser.register :dd_mm_yyyy_datetime do
      nil_if_empty
      require_format /\A(\d{2})\.(\d{2})\.(\d{4})\Z/
      begin
        DateTime.new match[3].to_i, match[2].to_i, match[1].to_i
      rescue ArgumentError
        parse_error 'is an invalid date'
      end
    end

    DumpParser.register :required_integer do
      require_format /\A(?:\d+)\Z/
      value.to_i(10)
    end
  end

  def execute(value)
    DumpParser.execute name,value
  end

  describe 'simple_map' do
    let(:name) { :simple_map }
    specify do
      execute('a').should == 'A'
      execute('b').should == 'B'
      execute('c').should == 'C'
      expect { execute 'unkown' }.to raise_error(DumpParser::ParseError,'simple_map: value "unkown" is not valid')
    end
  end

  describe 'dd_mm_yyyy_datetime' do
    let(:name) { :dd_mm_yyyy_datetime }
    specify do
      execute('10.01.1901').should == DateTime.new(1901,1,10)
      expect { execute 'unkown' }.to raise_error(DumpParser::ParseError,'dd_mm_yyyy_datetime: value "unkown" does not match required format')
      expect { execute '31.02.1901' }.to raise_error(DumpParser::ParseError,'dd_mm_yyyy_datetime: value "31.02.1901" is an invalid date')
    end
  end
end
