require 'rubygems'
require 'open4'


module SysMODB
  
  class SpreadsheetExtractionException < Exception
  end
  
  module SpreadsheetExtractor
    JAR_VERSION="0.9"
    DEFAULT_PATH = File.dirname(__FILE__) + "/../jars/simple-spreadsheet-extractor-#{JAR_VERSION}.jar"
    
    def spreadsheet_to_xml spreadsheet_data      
      if is_windows?              
        raise Exception.new("Windows is not currently supported")
      else        
        read_with_open4 spreadsheet_data,"xml"
      end
    end

    def spreadsheet_to_csv spreadsheet_data,sheet=1,trim=false
      if is_windows?
        raise Exception.new("Windows is not currently supported")
      else
        read_with_open4 spreadsheet_data,"csv",sheet,trim
      end
    end
    
    
    
    def spreadsheet_extractor_command format="xml",sheet=nil,trim=false
      command = "java -jar #{(defined? SPREADSHEET_EXTRACTOR_JAR_PATH) ? SPREADSHEET_EXTRACTOR_JAR_PATH : DEFAULT_PATH}"
      command +=  " -o #{format}"
      command += " -s #{sheet}" if sheet
      command += " -t" if trim
      command
    end
    
    private
       
    def is_windows?
        !(RUBY_PLATFORM =~ /mswin32/ || RUBY_PLATFORM =~ /mingw32/).nil?
    end        

    #opens using POpen4 - this is for the benefit of Windows. It has been found to be unstable in Linux and give occasional segmentation faults
    #def read_with_popen4 spreadsheet_data,format="xml",sheet=nil,trim=false
    #  output=""
    #  err_message = ""
    #  command = spreadsheet_extractor_command format,sheet,trim
    #  status = POpen4::popen4(command) do |stdout, stderr, stdin, pid|
    #    stdin=stdin.binmode
    #    spreadsheet_data.each_byte{|b| stdin.putc(b)}
    #    stdin.close
    #
    #    output=stdout.read.strip
    #    err_message=stderr.read.strip
    #
    #  end
    #
    #  if status.to_i != 0
    #    raise SpreadsheetExtractionException.new(err_message)
    #  end
    #
    #  output.strip
    #end
    
    def read_with_open4 spreadsheet_data,format="xml",sheet=nil,trim=false
      output = ""
      err_message = ""
      command = spreadsheet_extractor_command format,sheet,trim      
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
                  
      output.strip
    end
    
  end
end
