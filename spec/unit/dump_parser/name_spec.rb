require 'spec_helper'

describe DumpParser, '#name' do
  subject { object.name }

  let(:object) { described_class.new(name, {}) }
  let(:name)   { :test }

  it { should be(name) }

  it_should_behave_like 'an idempotent method'
end
