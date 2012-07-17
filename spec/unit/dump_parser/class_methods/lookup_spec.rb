require 'spec_helper'
describe DumpParser,'.lookup' do
  subject { object.lookup(name) }

  let(:object) { described_class }

  before :each do
    object.reset
  end

  context 'when requested parser was not registred' do
    let(:name) { :unknown }

    specify do
      expect { subject }.to raise_error(ArgumentError,'a parser named "unknown" is not registred')
    end
  end

  context 'when requested parser was registred' do
    let(:name)   { :test          }
    let(:parser) { mock('Parser') }

    before do
      DumpParser.stub(:new => parser)
      object.register(name, {})
    end

    context 'and name was given as string' do
      let(:lookup_name) { 'test' }
      it { should be(parser) }
    end

    context 'and name was given as symbol' do
      let(:lookup_name) { :test }
      it { should be(parser) }
    end
  end
end
