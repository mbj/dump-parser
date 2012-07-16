# encoding: utf-8

require 'spec_helper'

describe DumpParser, '.register' do
  subject { object.register(name,map,&block) }

  let(:object)      { described_class }
  let(:name)        { 'test' }
  let(:block)       { nil }
  let(:map)         { nil }
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
    let(:block) { lambda { 'value' } }
    it_should_behave_like 'a parser registration'
  end

  context 'with map' do
    let(:map)   { {} }
    it_should_behave_like 'a parser registration'
  end

  context 'with map and block' do
    let(:block) { lambda { 'value' } }
    let(:map)   { {} }
    it_should_behave_like 'a parser registration'
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
