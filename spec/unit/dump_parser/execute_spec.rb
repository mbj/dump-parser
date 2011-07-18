require 'spec_helper'

describe DumpParser, '#execute' do
  let(:name)   { :test }
  let(:map)    { nil }
  let(:block)  { nil }
  let(:object) { described_class.new(name,map,block) }

  subject { object.execute(value) }

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
end
