require File.join(File.dirname(__FILE__), '../' 'code', 'db.rb')

describe DB do
  it 'should initialize correctly' do
    db = DB.new('user', 'pass', 'db')
    db.user.should     == 'user'
    db.pass.should     == 'pass'
    db.database.should == 'db'
  end

  it 'should query correctly with 1 result' do
    db = DB.new('root', 'root', 'segments_tester')
    result = db.query 'select * from segments_tester.query_logs_correct ORDER BY query LIMIT 1;'
    result.fetch_row[0].should == "banka"
  end

  it 'should query correctly with >1 result' do
    db = DB.new('root', 'root', 'segments_tester')
    results = db.query 'select * from segments_tester.query_logs_correct ORDER BY query LIMIT 2;'
    results.fetch_row[0].should == "banka"
    results.fetch_row[0].should == "batovce"
  end

  it 'should query correctly with an empty string' do
    db = DB.new('root', 'root', 'segments_tester')
    results = db.query ''
    puts "Those error msgs are normal -- only part of our testing."
  end

end
