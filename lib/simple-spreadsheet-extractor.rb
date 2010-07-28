require 'rubygems'
require 'popen4'

module SysMODB
  
  class SpreadsheetExtractionException < Exception
  end
  
  module SpreadsheetExtractor
    
    JAR_PATH = File.dirname(__FILE__) + "/../jars"
    
    def spreadsheet_to_xml spreadsheet_data
      command = "java -jar #{JAR_PATH}/simple-spreadsheet-extractor-0.3.2.jar"
      output = ""
      err_message = ""
      status = POpen4::popen4(command) do |stdout, stderr, stdin, pid|
        spreadsheet_data.each_byte{|b| stdin.putc(b)}      
        stdin.close
                     
        output=stdout.read.strip                     
        err_message=stderr.read.strip
        
      end
            
      if status.to_i != 0                         
        raise SpreadsheetExtractionException.new(err_message)             
      end
                  
      return output
    end
    
  end
end