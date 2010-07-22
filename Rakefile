require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rubygems'

require 'rake/gempackagetask'

task :default => [:test]

#Rake::GemPackageTask.new do |pkg|
#  pkg.need_tar = true
#end

task:test do
  Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/test*.rb']
    t.verbose = true
  end

end