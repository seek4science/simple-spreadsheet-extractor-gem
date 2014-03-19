require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require 'rubygems'

require 'rubygems/package_task'

task :default => [:test]

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "simple-spreadsheet-extractor"
    gemspec.summary = "Basic spreadsheet content extraction using Apache POI"
    gemspec.description = "Takes a stream to a spreadsheet file and produces an XML or CSV representation of its contents"
    gemspec.email = "stuart.owen@manchester.ac.uk"
    gemspec.homepage = "http://github.com/myGrid/simple-spreadsheet-extractor-gem"
    gemspec.authors = ["Stuart Owen","Finn Bacall"]

    gemspec.has_rdoc = true
    gemspec.files.include %w(jars)
    gemspec.extra_rdoc_files = ["README.rdoc", "LICENCE"]
    gemspec.add_dependency("libxml-ruby",">=2.7.0")
    gemspec.add_dependency("open4","1.3.0")
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end

task:test do
  Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/test*.rb']
    t.verbose = true
  end
end

#end
