require 'open3'

module SysMODB
  module SpreadsheetExtractor
    
    JAR_PATH = File.dirname(__FILE__) + "/../jars"
    
    def spreadsheet_to_xml spreadsheet_data
      command = "java -jar #{JAR_PATH}/simple-spreadsheet-extractor-0.2.jar"
      stdin,stdout,stderr = Open3.popen3(command)          
      
      while ((line = spreadsheet_data.gets) != nil) do        
        stdin << line
      end
      stdin.close
      
#      if !(line=stderr.gets).nil?
#        msg=line
#        while ((line=stderr.gets)!= nil) do
#          msg << line
#        end
#        raise Exception.new(msg)
#      end
      
      output = ""      
      while ((line = stdout.gets) != nil) do
        output << line
      end      
      
      return output
    end
    
  end
end