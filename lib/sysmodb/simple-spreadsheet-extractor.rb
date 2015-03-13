
require 'sysmodb/extractor'

module SysMODB
  DEFAULT_MEMORY_ALLOCATION = '512M'

  module SpreadsheetExtractor
    def spreadsheet_to_xml(spreadsheet_data, memory_allocation = DEFAULT_MEMORY_ALLOCATION)
      SysMODB::Extractor.new(memory_allocation).spreadsheet_to_xml(spreadsheet_data)
    end

    def spreadsheet_to_csv(spreadsheet_data, sheet = 1, trim = false, memory_allocation = DEFAULT_MEMORY_ALLOCATION)
      SysMODB::Extractor.new(memory_allocation).spreadsheet_to_csv(spreadsheet_data, sheet, trim)
    end
  end
end
