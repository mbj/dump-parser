require 'spec_helper'

describe DumpParser::Executor, '.new' do
  subject { response }

  let(:response) { object.new(parser, input) }

  let(:object) { described_class                                              }
  let(:parser) { mock('Parser', :block => block, :map => map, :name => :test) }
  let(:input)  { mock('Input')                                                }
  let(:output) { mock('Output')                                               }
  let(:block)  { proc { fetch_map }                                           }
  let(:map)    { { input => output }                                          }

  it 'should be frozen' do 
    should be_frozen
  end

  context 'result' do
    subject { response.result }

    context 'with map' do
      let(:map) { { 'a' => 'b' } }

      context 'when value was in map' do
        let(:input) { 'a' }
        it { should eql('b') }
      end

      context 'when value was not in map' do
        let(:input) { 'invalid' }
        specify do
          expect { subject }.to raise_error(DumpParser::ParseError, 'test: with input "invalid" is not valid')
        end
      end
    end

    context 'with default block' do
      it 'should fetch from map' do
        should be(output)
      end

      context 'without map' do
        let(:map) { nil }

        it 'should raise error' do
          expect { subject }.to raise_error(DumpParser::ParseError, "test: with input #{input.inspect} this parser does not have a map")
        end
      end
    end

    context 'with block' do
      context 'all blocks' do
        let(:block) { proc { 'test' } }
        let(:input) { 'test' }
        it 'should return last expression from block' do
          should == 'test' 
        end
      end

      context 'nil_if_empty' do
        let(:block) { Proc.new { nil_if_empty } }

        context 'when empty' do
          let(:input) { '' }
          it { should == nil }
        end

        context 'when not empty' do
          let(:input) { 'test' }
          it { should be(input) }
        end

        context 'in sequence with other actions' do
          let(:input) { '' }
          let(:block) { Proc.new { nil_if_empty; require_format /\w+/ } }
          it 'should stop execution flow' do
            should be_nil
          end
        end
      end

      context 'error_if_empty' do
        let(:block) { Proc.new { error_if_empty } }

        context 'when empty' do
          let(:input) { '' }
          specify do 
            expect { subject }.to raise_error(DumpParser::ParseError, 'test: with input "" must not be empty')
          end
        end

        context 'when not empty' do
          let(:input) { 'test' }
          it { should be(input) } 
        end
      end

      context 'accessign match with no require_format' do
        let(:block) do
          proc do
            match
          end
        end

        it 'should raise error' do
          expect { subject }.to raise_error(DumpParser::ParseError, "test: with input #{input.inspect} no current match available")
        end
      end

      context 'require_format' do
        let(:block) do 
          proc do 
            require_format(/\Aabc\z/)
          end
        end

        context 'when match format' do
          let(:input) { 'abc' }
          it { should be(input) }

          context 'and using last match' do
            let(:input) { 'abc10' }

            let(:block) do
              proc do
                require_format(/\Aabc(\d+)\z/)
                match[1].to_i(10)
              end
            end

            it { should be(10) }
          end
        end

        context 'when not match format' do
          let(:input) { 'invalid' }
          specify do
            expect { subject }.to(
              raise_error(DumpParser::ParseError, 'test: with input "invalid" does not match required format')
            )
          end
        end
      end
    end
  end
end
