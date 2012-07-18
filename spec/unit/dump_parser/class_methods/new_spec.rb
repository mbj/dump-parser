require 'spec_helper'

describe DumpParser, '.new' do
  subject { object.new(*arguments) }

  let(:name)      { :test     }
  let(:map)       { {}        }
  let(:block)     { lambda {} }

  let(:object) { described_class }

  shared_examples_for 'a dump parser' do
    it { should be_instance_of(object) }
    it { should be_frozen }
    its(:name) { should == name }
  end

  context 'with name and map' do
    let(:arguments) { [name, map] }

    it_should_behave_like 'a dump parser'
  end

  context 'with name map and block' do
    let(:arguments) { [name, map, block] }

    it_should_behave_like 'a dump parser'
  end

  context 'without name and block' do
    let(:arguments) { [name] }

    it do
      expect { subject }.to raise_error(ArgumentError, 'need map block or both')
    end
  end
end

