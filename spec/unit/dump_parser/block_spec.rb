require 'spec_helper'

describe DumpParser, '#block' do
  subject { object.block }

  let(:name)   { :test                                 }
  let(:object) { described_class.new(name, map, block) }
  let(:map)    { {}                                    }

  context 'parser has block' do
    let(:block) { proc {} }

    it { should be(block) }

    it_should_behave_like 'an idempotent method'
  end

  context 'parser not has' do
    let(:block) { nil }

    it { should be(DumpParser::DEFAULT_BLOCK) }

    it_should_behave_like 'an idempotent method'
  end
end
