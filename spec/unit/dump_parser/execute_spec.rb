require 'spec_helper'

describe DumpParser,'#execute' do
  subject { object.execute(input) }

  let(:input)    { 'Input'                             }
  let(:object)   { described_class.new(name,map)       }
  let(:name)     { :test                               }
  let(:map)      { mock('Map')                         }
  let(:result)   { mock('Result')                      }
  let(:executor) { mock('Executor', :result => result) }

  before do
    DumpParser::Executor.stub(:new => executor)
  end

  it { should be(result) }

  it 'should initialize executor with parser and input' do
    DumpParser::Executor.should_receive(:new).with(object,input).and_return(executor)
    should be(result)
  end
end
