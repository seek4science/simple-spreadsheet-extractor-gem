
require 'sysmodb/extractor'

module SysMODB
  DEFAULT_MEMORY_ALLOCATION = '512M'

  # The mixin to allow you to extract from a spreadsheet file using
  #   simple_spreadsheet_to_xml to extract to an xml format (see README and schema in doc/schema-v1.xsd)
  #   simple_spreadhseet_to_csv to extract to CSV format for a single sheet
  module SpreadsheetExtractor

    # :call-seq:
    #   spreadsheet_to_xml(spreadsheet_data) -> String
    #   spreadsheet_to_xml(spreadsheet_data, memory_allocation) -> String
    #
    # reads the incoming data from an IO object and returns the generated XML.
    # it is extracted using java, and the default memory allocation is 512M (passed to -Xmx) this can
    # be changed by passing an option final parameter memory_allocation
    def spreadsheet_to_xml(spreadsheet_data, memory_allocation = DEFAULT_MEMORY_ALLOCATION)
      SysMODB::Extractor.new(memory_allocation).spreadsheet_to_xml(spreadsheet_data)
    end

    # :call-seq:
    #   spreadsheet_to_csv(spreadsheet_data) -> String
    #   spreadsheet_to_csv(spreadsheet_data, sheet) -> String
    #   spreadsheet_to_csv(spreadsheet_data, sheet, trim) -> String
    #   spreadsheet_to_csv(spreadsheet_data, sheet, trim, memory_allocation) -> String
    #
    # reads the incoming data from an IO object and returns the generated CSV.
    # only 1 sheet is processed, which by default it the first sheet.
    # if trim is set to true, proceeding or trailing cells will be removed whilst keeping the csv uniform.
    # it is extracted using java, and the default memory allocation is 512M (passed to -Xmx) this can
    # be changed by passing an option final parameter memory_allocation
    def spreadsheet_to_csv(spreadsheet_data, sheet = 1, trim = false, memory_allocation = DEFAULT_MEMORY_ALLOCATION)
      SysMODB::Extractor.new(memory_allocation).spreadsheet_to_csv(spreadsheet_data, sheet, trim)
    end
  end
end
