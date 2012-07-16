require 'spec_helper'

describe DumpParser,'.execute' do
  subject { object.execute(name,input) }

  let(:name)     { mock('Name')                      }
  let(:input)    { 'Input'                           }
  let(:parser)   { mock('Parser',:execute => result) }
  let(:result)   { mock('Result')                    }
  let(:object)   { described_class                   }

  before do
    object.stub(:lookup => parser)
  end
  
  it 'should return result' do
    should be(result)
  end

  it 'should lookup parser with name' do
    object.should_receive(:lookup).with(name).and_return(parser)
    should be(result)
  end

  it 'should execute parser with input' do
    parser.should_receive(:execute).with(input).and_return(result)
    should be(result)
  end
end
