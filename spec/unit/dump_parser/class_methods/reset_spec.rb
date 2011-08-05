require 'spec_helper'

describe DumpParser, '.reset!' do
  subject { object }
  # this is a litte bit stubid but revious tests can leak parsers
  # will solve this later
  before do
    object.reset!
  end
  let(:object)           { DumpParser }
  let(:name)             { :test }

  before do
    object.register(name) { "value" }
    object.reset!
  end

  it { should_not have_parser(name) }
  its(:names) { should == [] }
end
