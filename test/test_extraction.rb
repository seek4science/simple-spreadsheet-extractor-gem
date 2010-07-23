require 'test/unit'
require 'spreadsheet-extractor'

class TestExtraction < Test::Unit::TestCase
  
  include SysMODB::SpreadsheetExtractor
  
  
  def test_from_stream    
    test_sheet = File.dirname(__FILE__) + "/test-spreadsheet.xls"
    f=open(test_sheet)
    puts spreadsheet_to_xml(f)
    assert_not_nil spreadsheet_to_xml(f)
  end
  
end