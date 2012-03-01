require 'test/unit'
require 'simple-spreadsheet-extractor'
require 'libxml'

class TestExtraction < Test::Unit::TestCase
  
  SCHEMA_FILE_PATH = File.dirname(__FILE__) + "/../doc/schema-v1.xsd"
  
  include SysMODB::SpreadsheetExtractor
  
  def test_from_file_object
    test_sheet = File.dirname(__FILE__) + "/files/test-spreadsheet.xls"
    f=open(test_sheet,"rb")
    xml = spreadsheet_to_xml(f)
    assert_not_nil xml
  end

  def test_from_non_file_io_object
    test_sheet = File.dirname(__FILE__) + "/files/test-spreadsheet.xls"
    contents = open(test_sheet, "rb") {|io| io.read }
    io=StringIO.new contents
    assert_nil io.path
    xml = spreadsheet_to_xml(io)
  end
  
  def test_validate_xml
    test_sheet = File.dirname(__FILE__) + "/files/test-spreadsheet.xls"
    f=open(test_sheet,"rb")
    xml = spreadsheet_to_xml(f)
    validate_against_schema(xml)
  end

  def test_failure
    test_sheet = File.dirname(__FILE__) + "/files/not-a-spreadsheet.xls"
    f=open(test_sheet,"rb")
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

  def test_csv_output
    test_sheet = File.dirname(__FILE__) + "/files/test-spreadsheet.xls"
    expected_file = File.dirname(__FILE__) + "/files/test-csv-output1.csv"
    expected = open(expected_file,"rb").read

    f=open(test_sheet,"rb")
    csv = spreadsheet_to_csv(f,2)
    assert_equal expected,csv

    #try sheet as a string
    f=open(test_sheet,"rb")
    csv = spreadsheet_to_csv(f,"2")
    assert_equal expected,csv
  end

#  def test_csv_output_trimmed
#    test_sheet = File.dirname(__FILE__) + "/files/test-spreadsheet.xls"
#    expected_file = File.dirname(__FILE__) + "/files/test-csv-output1-trimmed.csv"
#    expected = open(expected_file,"rb").read
#
#    f=open(test_sheet,"rb")
#    csv = spreadsheet_to_csv(f,2,true)
#    assert_equal expected,csv
#  end

  def test_for_segfault
    test_sheet = File.dirname(__FILE__) + "/files/test-spreadsheet.xls"
    10.times do |x|
      f=open(test_sheet,"rb")
      xml = spreadsheet_to_xml(f)
    end
    true
  end
  
end
