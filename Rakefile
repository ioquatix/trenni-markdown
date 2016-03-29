require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :console do
	require "bundler/setup"
	require_relative "lib/trenni/markdown"
	
	require "pry"
	Pry.start
end
