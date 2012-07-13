require "bundler/gem_tasks"

require 'rake/testtask'
desc 'Test the http_accept_language plugin.'
Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/**/*_test.rb'
end

desc 'Default: run unit tests.'
task :default => :test
