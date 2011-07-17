require 'spec_helper'

describe DumpParser,'.has_parser?' do
  let(:object)        { described_class }
  let(:name)          { :test }

  before do
    object.reset!
  end

  subject { object.has_parser? name }

  context 'when parser with name exists' do
    before do
      object.register name, {}
    end

    it { should be_true }
  end

  context 'when parser with name does not exist' do
    it { should be_false }
  end
end
