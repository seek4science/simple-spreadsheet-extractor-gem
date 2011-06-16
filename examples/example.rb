require 'rubygems'
require 'simple-spreadsheet-extractor'

include SysMODB::SpreadsheetExtractor

path=ARGV.first

f=open(path)
begin
  puts spreadsheet_to_xml(f)
rescue SysMODB::SpreadsheetExtractionException=>e
  puts "Something went wrong #{e.message}"
end
