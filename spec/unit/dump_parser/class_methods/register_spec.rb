# encoding: utf-8

require 'spec_helper'

describe DumpParser, '.register' do
  let(:object)      { described_class }
  let(:name)        { :test }
  let(:block)       { nil }
  let(:map)         { nil }
  let(:parser)      { Object.new }

  let(:returned_parser) { @returned_parser }

  before do
    object.reset!
    object.should_receive(:new).with(name,map,block).and_return(parser)
    @returned_parser = object.register(name,map,&block)
  end

  shared_examples_for 'a parser registration' do
    context 'returned parser' do
      subject { returned_parser }
      it { should == parser }
    end

    context 'registry' do
      subject { object }
      it { should have_parser name }
      its(:names) { should include(name) }
    end
  end

  context 'with block' do
    let(:block) { lambda { "value" } }
    it_should_behave_like 'a parser registration'
  end

  context 'with map' do
    let(:map) { {} }
    it_should_behave_like 'a parser registration'
  end

  context 'with map and block' do
    let(:block) { lambda { "value" } }
    let(:map) { {} }
    it_should_behave_like 'a parser registration'
  end

  context 'name was already regsitred' do
    specify do
      expect { object.register name,{} }.to raise_error(ArgumentError,"a parser named :test is already registred")
    end
  end
end
