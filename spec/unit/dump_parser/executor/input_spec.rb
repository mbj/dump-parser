require 'spec_helper'

describe DumpParser::Executor, '#input' do
  subject { object.input }

  let(:object) { described_class.new(parser, input)                                     }
  let(:parser) { mock('Parser', :block => proc { fetch_map }, :map => { input => :foo}) }
  let(:input)  { mock('Input')                                                          }

  it_should_behave_like 'an idempotent method'

  it { should be(input) }
end
