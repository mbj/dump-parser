require 'spec_helper'

describe DumpParser,'.has_parser?' do
  let(:object)        { described_class }
  let(:name)          { 'test' }

  before do
    object.reset!
  end

  subject { object.has_parser? lookup_name }

  context 'when parser with name exists' do
    before do
      object.register name, {}
    end

    context 'when giving a string' do
      let(:lookup_name) { 'test' }
      it { should be_true }
    end

    context 'when giving a symbol' do
      let(:lookup_name) { :test }
      it { should be_true }
    end

  end

  context 'when parser with name does not exist' do
    let(:lookup_name) { 'other' }
    it { should be_false }
  end
end
