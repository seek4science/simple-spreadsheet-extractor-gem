require 'test/unit'
require 'spreadsheet-parser'

class TestExtraction < Test::Unit::TestCase
  
  include SysMODB::SpreadsheetExtractor
  
  def test_from_stream
    data=""
    puts spreadsheet_to_xml(data)
    assert_not_nil spreadsheet_to_xml(data)
  end
  
end