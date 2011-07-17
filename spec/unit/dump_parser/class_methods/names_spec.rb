require 'spec_helper'

describe DumpParser, '.names' do
  let(:object)  { described_class }
  let(:subject) { object.names }

  before do
    DumpParser.reset!
  end


  context 'when a parser named :test was registred' do
    before do
      object.register :test, {}
    end
   
    it { should == [:test] }
  end

  context 'when no parser was registred' do
    it { should == [] }
  end

  context 'when many parsers where registred' do
    before do
      object.register :a, {}
      object.register :b, {}
      object.register :c, {}
    end

    it 'should return parser names in registration order' do
      should == [:a,:b,:c]
    end
  end
end
