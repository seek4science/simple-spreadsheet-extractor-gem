require 'test_helper'

class ExtractionTest < Minitest::Test
  
  SCHEMA_FILE_PATH = File.dirname(__FILE__) + "/../doc/schema-v1.xsd"
  
  include SysMODB::SpreadsheetExtractor

  def test_from_non_file_io_object
    test_sheet = File.dirname(__FILE__) + "/files/test-spreadsheet.xls"
    contents = open(test_sheet, "rb") {|io| io.read }
    io=StringIO.new contents
    xml = spreadsheet_to_xml(io)
    validate_against_schema(xml)
  end

  def test_from_file_path_string
    test_sheet_path = File.dirname(__FILE__) + "/files/test-spreadsheet.xls"
    xml = spreadsheet_to_xml(test_sheet_path)
    validate_against_schema(xml)
  end
  
  def test_validate_xml
    test_sheet = File.dirname(__FILE__) + "/files/test-spreadsheet.xls"
    f=open(test_sheet,"rb")
    xml = spreadsheet_to_xml(f)
    validate_against_schema(xml)
  end

  def test_validate_xml_xlsx
    test_sheet = File.dirname(__FILE__) + "/files/test-spreadsheet.xlsx"
    f=open(test_sheet,"rb")
    xml = spreadsheet_to_xml(f)
    validate_against_schema(xml)
  end

  def test_failure
    test_sheet = File.dirname(__FILE__) + "/files/not-a-spreadsheet.xls"
    f=open(test_sheet,"rb")
    err = assert_raises SysMODB::SpreadsheetExtractionException do
      spreadsheet_to_xml(f)
    end
    assert_match /Invaild format reading data/, err.message
  end

  def test_problem_with_dv
    test_sheet = File.dirname(__FILE__) + "/files/problem_with_dv.xls"
    f=open(test_sheet,"rb")
    xml = spreadsheet_to_xml(f)
    validate_against_schema(xml)
  end

  def test_invalid_xml_chars
    test_sheet = File.dirname(__FILE__) + "/files/xml-unfriendly-chars.xlsx"
    f=open(test_sheet,"rb")
    xml = spreadsheet_to_xml(f)
    validate_against_schema(xml)
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
    expected = open(expected_file,"rb").read.strip

    f=open(test_sheet,"rb")
    csv = spreadsheet_to_csv(f,2)
    assert_equal expected,csv

    #try sheet as a string
    f=open(test_sheet,"rb")
    csv = spreadsheet_to_csv(f,"2")
    assert_equal expected,csv
  end

  def test_csv_output_from_filepath
    test_sheet_path = File.dirname(__FILE__) + "/files/test-spreadsheet.xls"
    expected_file = File.dirname(__FILE__) + "/files/test-csv-output1.csv"
    expected = open(expected_file,"rb").read.strip

    csv = spreadsheet_to_csv(test_sheet_path,2)
    assert_equal expected,csv

    #try sheet as a string
    csv = spreadsheet_to_csv(test_sheet_path,"2")
    assert_equal expected,csv
  end

  def test_for_segfault
    test_sheet = File.dirname(__FILE__) + "/files/test-spreadsheet.xls"
    5.times do |x|
      f=open(test_sheet,"rb")
      xml = spreadsheet_to_xml(f)
      validate_against_schema(xml)
    end
    true
  end
  
end
