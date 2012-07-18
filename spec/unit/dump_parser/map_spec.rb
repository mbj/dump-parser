require 'spec_helper'

describe DumpParser, '#map' do
  subject { object.map }

  let(:object) { described_class.new(:test, *arguments) }
  let(:map)    { mock('Map')                           }
  
  context 'when map is given' do
    let(:arguments) { [map] }

    it { should be(map) }
  end

  context 'when map is NOT given' do
    let(:arguments) { [nil, proc {}] }

    it { should be(nil) }
  end
end
