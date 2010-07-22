module SysMODB
  module SpreadsheetExtractor
    
    JAR_PATH = File.dirname(__FILE__) + "/../jars"
    
    def spreadsheet_to_xml spreadsheet_data
      command = "cat /home/sowen/test-spreadsheet.xls | java -jar #{JAR_PATH}/spreadsheet-parser-0.1.jar"
      return exec(command)
    end
    
  end
end