require 'test/unit'
require 'simple-spreadsheet-extractor'
require 'libxml'

class TestExtraction < Test::Unit::TestCase
  
  SCHEMA_FILE_PATH = File.dirname(__FILE__) + "/../doc/schema-v1.xsd"
  
  include SysMODB::SpreadsheetExtractor
  
  def test_from_file_object    
    test_sheet = File.dirname(__FILE__) + "/test-spreadsheet.xls"
    f=open(test_sheet)    
    xml = spreadsheet_to_xml(f)     
    puts xml
    assert_not_nil xml      
  end
  
  def test_validate_xml
    test_sheet = File.dirname(__FILE__) + "/test-spreadsheet.xls"
    f=open(test_sheet)    
    xml = spreadsheet_to_xml(f)
    validate_against_schema(xml)
  end
  
  def test_failure
    test_sheet = File.dirname(__FILE__) + "/not-a-spreadsheet.xls"
    f=open(test_sheet)
    assert_raise SysMODB::SpreadsheetExtractionException do 
      spreadsheet_to_xml(f)      
    end
  end
  
  def validate_against_schema xml
    document = LibXML::XML::Document.string(xml)    
    schema = LibXML::XML::Schema.new(SCHEMA_FILE_PATH)    
    begin
      document.validate_schema(schema)
    rescue LibXML::XML::Error => e          
      puts xml
      assert false,"Error validating against schema: #{e.message}"
    end
  end
  
  
end