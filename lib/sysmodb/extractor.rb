require 'open4'

module SysMODB
  class SpreadsheetExtractionException < Exception; end

  class Extractor
    JAR_VERSION="0.15.0"
    DEFAULT_PATH = File.dirname(__FILE__) + "/../../jars/simple-spreadsheet-extractor-#{JAR_VERSION}.jar"
    BUFFER_SIZE=250000 # 1/4 a megabyte

    def initialize(memory_allocation)
      @memory_allocation = memory_allocation
      if is_windows?
        raise Exception.new("Windows is not currently supported")
      end
    end

    def spreadsheet_to_xml(spreadsheet_data)
      read_with_open4 spreadsheet_data,"xml"
    end

    def spreadsheet_to_csv(spreadsheet_data,sheet=1,trim=false)
      read_with_open4 spreadsheet_data,"csv",sheet,trim
    end

    private

    def spreadsheet_extractor_command(format="xml",sheet=nil,trim=false)
      command = "java -Xmx#{@memory_allocation} -jar #{(defined? SPREADSHEET_EXTRACTOR_JAR_PATH) ? SPREADSHEET_EXTRACTOR_JAR_PATH : DEFAULT_PATH}"
      command +=  " -o #{format}"
      command += " -s #{sheet}" if sheet
      command += " -t" if trim
      command
    end

    def is_windows?
      !(RUBY_PLATFORM =~ /mswin32/ || RUBY_PLATFORM =~ /mingw32/).nil?
    end

    def read_with_open4(spreadsheet_data,format="xml",sheet=nil,trim=false)
      output = ""
      err_message = ""
      command = spreadsheet_extractor_command format,sheet,trim
      status = Open4.popen4(command) do |_pid, stdin, stdout, stderr|
        while ((line = spreadsheet_data.gets(BUFFER_SIZE)) != nil) do
          stdin << line
        end
        stdin.close

        while ((line = stdout.gets(BUFFER_SIZE)) != nil) do
          output << line
        end
        stdout.close

        until ((line=stderr.gets((BUFFER_SIZE))).nil?) do
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
