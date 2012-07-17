# encoding: utf-8

require 'spec_helper'

describe DumpParser, '.register' do
  subject { object.register(name,*arguments,&block) }

  let(:object)      { described_class }
  let(:name)        { 'test' }
  let(:map)         { {} }
  let(:parser)      { mock('Parser') }

  before do
    object.reset
    described_class.stub(:new => parser)
  end

  shared_examples_for 'a parser registration' do
    it { should be_present(name) }
    its(:names) { should include(name) }

    it_should_behave_like 'a command method'
  end

  context 'with block' do
    let(:arguments) { [] }
    let(:block)     { lambda { 'value' } }

    it 'should create parser' do
      described_class.should_receive(:new).with(name,nil,block).and_return(parser)
      subject
    end
  end

  context 'with map' do
    let(:arguments) { [map] }
    let(:block)     { nil }
    it_should_behave_like 'a parser registration'

    it 'should create parser' do
      described_class.should_receive(:new).with(name,map,nil).and_return(parser)
      subject
    end
  end

  context 'with map and block' do
    let(:arguments) { [map] }
    let(:block)     { lambda { 'value' } }
    it_should_behave_like 'a parser registration'

    it 'should create parser' do
      described_class.should_receive(:new).with(name,map,block).and_return(parser)
      subject
    end
  end

  context 'name was already regsitred' do
    before do
      object.register(name,{})
    end

    it 'should raise error' do
      expect { object.register(name,{}) }.to raise_error(ArgumentError,'a parser named "test" is already registred')
    end
  end
end
