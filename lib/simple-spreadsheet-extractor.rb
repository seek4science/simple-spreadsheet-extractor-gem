require 'rubygems'
require 'open4'

module SysMODB
  
  class SpreadsheetExtractionException < Exception
  end
  
  module SpreadsheetExtractor
    
    JAR_PATH = File.dirname(__FILE__) + "/../jars"
    
    def spreadsheet_to_xml spreadsheet_data
      command = "java -jar #{JAR_PATH}/simple-spreadsheet-extractor-0.3.2.jar"
      output = ""
      err_message = ""
      status = Open4::popen4(command) do |pid, stdin, stdout, stderr|
        while ((line = spreadsheet_data.gets) != nil) do        
          stdin << line
        end
        stdin.close
                     
        while ((line = stdout.gets) != nil) do
          output << line
        end      
        stdout.close
                
        while ((line=stderr.gets)!= nil) do
          err_message << line
        end
        stderr.close
      end
            
      if status.to_i != 0                 
        raise SpreadsheetExtractionException.new(err_message)             
      end
                  
      return output
    end
    
  end
end