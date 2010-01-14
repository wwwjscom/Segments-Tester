require File.join(File.dirname(__FILE__), '../', 'code', 'directories_setup.rb')
require File.join(File.dirname(__FILE__), '../', 'code', 'queryToNgramToVote.rb')
require File.join(File.dirname(__FILE__), '../', 'code', 'config_parser.rb')

describe Ngrams do

  before do
    @config = Configure.get_parser
  end

  it 'should initialize correctly with a 3gram' do
    ngram = Ngrams.new(3, @config)
  end

  it 'should initialize correctly with a 4gram' do
    ngram = Ngrams.new(4, @config)
  end

  it 'should query correctly with a 3gram' do
    ngram = Ngrams.new(3, @config)
    ngram.query
  end

  it 'should query correctly with a 4gram' do
    ngram = Ngrams.new(4, @config)
    ngram.query
  end

end
