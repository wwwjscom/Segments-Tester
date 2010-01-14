require File.join(File.dirname(__FILE__), '../' 'code', 'soundex.rb')

describe String do
  it 'should encode correctly' do
    "Quadratically".soundex.should == 'Q363'
    "Quadratically".soundex(false).should == 'Q36324'
  end

  it 'should tell me whether 2 words sound similar' do
    "Quadratically".sounds_like("Quadratically").should == true
  end
end
