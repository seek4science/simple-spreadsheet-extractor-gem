require 'open3'

module SysMODB
  module SpreadsheetExtractor
    
    JAR_PATH = File.dirname(__FILE__) + "/../jars"
    
    def spreadsheet_to_xml spreadsheet_data
      command = "java -jar #{JAR_PATH}/spreadsheet-parser-0.1.jar"
      stdin,stdout,stderr = Open3.popen3(command)
      
      while ((line = spreadsheet_data.gets) != nil) do        
        stdin << line
      end
      stdin.close
      
      output = ""      
      while ((line = stdout.gets) != nil) do
        output << line
      end      
      
      return output
    end
    
  end
end