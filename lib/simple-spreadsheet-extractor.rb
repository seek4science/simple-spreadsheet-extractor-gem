require 'rubygems'
require 'popen4'
require 'open4'


module SysMODB
  
  class SpreadsheetExtractionException < Exception
  end
  
  module SpreadsheetExtractor
    
    JAR_PATH = File.dirname(__FILE__) + "/../jars"
    COMMAND = "java -jar #{JAR_PATH}/simple-spreadsheet-extractor-0.3.2.jar"
    
    def spreadsheet_to_xml spreadsheet_data
      if RUBY_PLATFORM =~ /mswin32/
        output = read_with_popen4 spreadsheet_data
      else        
        output = read_with_open4 spreadsheet_data
      end
      
      return output
    end
    
    private
    
    #opens using POpen4 - this is for the benefit of Windows. It has been found to be unstable in Linux and give occaisional segmentation faults
    def read_with_popen4 spreadsheet_data
      output=""
      err_message = ""
      status = POpen4::popen4(COMMAND) do |stdout, stderr, stdin, pid|
        stdin=stdin.binmode
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
    
    def read_with_open4 spreadsheet_data
      output = ""
      err_message = ""
      status = Open4::popen4(COMMAND) do |pid, stdin, stdout, stderr|
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