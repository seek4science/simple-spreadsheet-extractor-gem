require 'test/unit'
require 'simple-spreadsheet-extractor'


class TestExtraction < Test::Unit::TestCase
  
  include SysMODB::SpreadsheetExtractor
  
  def test_from_file_object    
    test_sheet = File.dirname(__FILE__) + "/test-spreadsheet.xls"
    f=open(test_sheet)    
    xml = spreadsheet_to_xml(f)   
    assert_not_nil xml  
    puts xml
  end
  
  def test_failure
    test_sheet = File.dirname(__FILE__) + "/not-a-spreadsheet.xls"
    f=open(test_sheet)
    assert_raise SysMODB::SpreadsheetExtractionException do 
      spreadsheet_to_xml(f)      
    end
  end
  
end