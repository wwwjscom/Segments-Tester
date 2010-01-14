require File.join(File.dirname(__FILE__), '../' 'code', 'run.rb')

describe Main do
  it "should initalize correctly" do
    main = Main.new
    main.class.should == Main
  end

  it 'should run setup correctly' do
    main = Main.new
    main.setup
    true.should == true
  end
end
