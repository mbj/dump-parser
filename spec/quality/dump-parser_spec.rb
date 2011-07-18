require 'spec_helper'

describe DumpParser do
  it 'should not contain reek' do 
    (Dir["#{File.dirname(__FILE__)}/../../lib/**/*.rb"]).should_not reek
  end
end
