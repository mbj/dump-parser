require 'spec_helper'

describe DumpParser, '.reset!' do
  subject { object }
  let(:object)           { DumpParser }
  let(:name)             { :test }

  before do
    object.register(name) { "value" }
    object.reset!
  end

  it { should_not have_parser(name) }
  its(:names) { should == [] }
end
