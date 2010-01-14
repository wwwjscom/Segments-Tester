require File.join(File.dirname(__FILE__), '../' 'code', 'run.rb')

describe Main do
  it "should initalize correctly" do
    main = Main.new
    main.class.should == Main
  end
end
