require 'spec_helper'

describe DumpParser, '#execute' do
  let(:name)   { :test }
  let(:map)    { nil }
  let(:block)  { nil }
  let(:object) { described_class.new(name,map,block) }

  subject { object.execute(value) }

  after :each do
    object.send(:value).should be_nil
    object.instance_variable_get(:'@match').should be_nil 
    object.instance_variable_get(:'@result').should be_nil
  end

  context 'with map' do
    let(:map) { { 'a' => 'b' } }

    context 'when value was in map' do
      let(:value) { 'a' }
      it { should == 'b' }
    end

    context 'when value was not in map' do
      let(:value) { 'invalid' }
      specify do
        expect { subject }.to raise_error(DumpParser::ParseError,'test: value "invalid" is not valid')
      end
    end
  end

  context 'with block' do
    context 'when no string was given' do
      let(:value) { nil }
      let(:block) { Proc.new {} }
      specify do
        expect { subject }.to raise_error(ArgumentError,'test: parse input "nil" must be kind of String')
      end
    end

    context 'all blocks' do
      let(:block) { Proc.new { 'test' } }
      let(:value) { 'test' }
      it 'should return last expression from block' do
        should == 'test' 
      end
    end

    context 'nil_if_empty' do
      let(:block) { Proc.new { nil_if_empty } }

      context 'when empty' do
        let(:value) { '' }
        it { should == nil }
      end

      context 'when not empty' do
        let(:value) { 'test' }
        it { should == value }
      end

      context 'in sequence with other actions' do
        let(:value) { '' }
        let(:block) { Proc.new { nil_if_empty; require_format /\w+/ } }
        it 'should stop execution flow' do
          should be_nil
        end
      end
    end

    context 'error_if_empty' do
      let(:block) { Proc.new { error_if_empty } }

      context 'when empty' do
        let(:value) { '' }
        specify do 
          expect { subject }.to raise_error(DumpParser::ParseError,'test: value "" must not be empty')
        end
      end

      context 'when not empty' do
        let(:value) { 'test' }
        it { should == value } 
      end
    end

    context 'require_format' do
      let(:pattern) { %r(\Aabc\Z) }
      let(:block) { pattern = self.pattern; Proc.new { require_format pattern } }

      context 'when match format' do
        let(:value) { 'abc' }
        it { should == value }

        it 'should remember match for later processing' do
          subject
          object.send(:match).should == pattern.match(value)
        end
      end

      context 'when not match format' do
        let(:value) { 'invalid' }
        specify do
          expect { subject }.to raise_error(DumpParser::ParseError,'test: value "invalid" does not match required format')
        end
      end
    end
  end
end
