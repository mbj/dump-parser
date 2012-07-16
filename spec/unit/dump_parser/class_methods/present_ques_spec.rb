require 'spec_helper'

describe DumpParser,'.present?' do
  let(:object)        { described_class }
  let(:name)          { 'test' }

  before do
    object.reset
  end


  subject { object.present?(name) }

  context 'when parser with name exists' do
    before do
      object.register name, {}
    end

    context 'when giving a string' do
      let(:name) { 'test' }
      it { should be(true) }
      it_should_behave_like 'an idempotent method'
    end

    context 'when giving a symbol' do
      let(:name) { :test }
      it { should be(true) }
      it_should_behave_like 'an idempotent method'
    end

  end

  context 'when parser with name does not exist' do
    let(:name) { 'other' }
    it { should be(false) }
    it_should_behave_like 'an idempotent method'
  end
end
