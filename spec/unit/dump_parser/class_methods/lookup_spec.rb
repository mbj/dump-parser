require 'spec_helper'
describe DumpParser do
  let(:object) { described_class }
  let(:parser) { object.register name, {} }


  let(:name) { :test }

  let(:lookup_name) { name }
  

  before :each do
    object.reset!
    parser
  end

  subject { object.lookup lookup_name }

  context 'when requested parser was not registred' do
    let(:lookup_name) { :unkown }
    specify do
      expect { subject }.to raise_error(ArgumentError,'a parser named :unkown is not registred')
    end
  end

  context 'when requested parser was registred' do
    it { should == parser }
  end
end
