require 'spec_helper'

describe DumpParser::Executor, '#result' do
  subject { object.result }

  let(:object) { described_class.new(parser, input)                                        }
  let(:parser) { mock('Parser', :block => proc { fetch_map }, :map => { input => result }) }
  let(:input)  { mock('Input')                                                             }
  let(:result) { mock('Result')                                                            }

  it_should_behave_like 'an idempotent method'

  it { should be(result) }
end
