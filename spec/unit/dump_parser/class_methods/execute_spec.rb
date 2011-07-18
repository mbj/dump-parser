require 'spec_helper'

describe DumpParser,'.execute' do
  let(:object)     { described_class }

  let(:name)       { :test }
  let(:value)      { 'value' }
  let(:parser)     { Object.new }


  it 'should lookup and execute the parser' do
    DumpParser.should_receive(:lookup).with(name).and_return(parser)
    parser.should_receive(:execute).with(value).and_return(nil)
    DumpParser.execute(name,value).should be_nil
  end
end
