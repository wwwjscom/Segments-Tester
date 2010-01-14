require File.join(File.dirname(__FILE__), 'code', 'directories_setup.rb')
require 'rake'

namespace :tester do
  desc 'Executes the core program'
  task :run do
    # do stuff here
  end
end

namespace :rspec do
  require 'spec/rake/spectask'
  desc 'Run all Rspec tests'
  Spec::Rake::SpecTask.new('all') do |t|
    t.spec_files = FileList[File.join(TEST_DIR, '*.rb')]
  end

  desc "Run all tests with RCov"
  Spec::Rake::SpecTask.new('coverage') do |t|
    t.spec_files = FileList[File.join(TEST_DIR, '*.rb')]
    t.rcov = true
  end


end
