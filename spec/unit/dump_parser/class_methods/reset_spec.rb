require 'spec_helper'

describe DumpParser, '.reset' do
  subject { object.reset }

  before do
    object.reset
  end

  let(:object)           { DumpParser }
  let(:name)             { :test }

  before do
    object.register(name) { "value" }
    object.reset
  end

  it { should_not be_present(name) }
  its(:names) { should eql([]) }
end
