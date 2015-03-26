require 'rake/testtask'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc 'Run tests'
task :default => :test
