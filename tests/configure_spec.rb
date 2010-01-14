require File.join(File.dirname(__FILE__), '../' 'code', 'config_parser.rb')

describe Configure do
  it 'should initialize correctly' do
    c = Configure.new
    c.class.should == Configure
  end
end
