# encoding: utf-8

require 'spec_helper'

describe DumpParser, '.register' do
  subject { object.register(name,map,&block) }

  let(:object)      { described_class }
  let(:name)        { :test }
  let(:block)       { nil }
  let(:map)         { nil }

  before do
    object.reset!
  end

  shared_examples_for 'a parser registration' do
    it { should have_parser(name) }
    it { should == described_class }
  end

  context 'with block' do
    let(:block) { lambda { "value" } }

    it 'should create a DumpParser object with block' do
      described_class.should_receive(:new).with(name,nil,block).and_return(Object.new)
      subject
    end

    it_should_behave_like 'a parser registration'
  end

  context 'with map' do
    let(:map) { {} }

    it 'should create a DumpParser object with map' do
      described_class.should_receive(:new).with(name,map,nil).and_return(Object.new)
      subject
    end

    it_should_behave_like 'a parser registration'
  end

  context 'with map and block' do
    let(:block) { lambda { "value" } }
    let(:map) { {} }

    it 'should create a DumpParser object with map and block' do
      described_class.should_receive(:new).with(name,map,block).and_return(Object.new)
      subject
    end

    it_should_behave_like 'a parser registration'
  end
end
