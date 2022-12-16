require 'open4'

module SysMODB
  #Exception that is thrown when a problem occurs during the extraction
  class SpreadsheetExtractionException < Exception; end

  #handles the delegation to java, and executes the extraction passing the
  #input file through STDIN, and reading the results through STDOUT.
  class Extractor
    JAR_VERSION="0.16.0".freeze
    DEFAULT_PATH = File.dirname(__FILE__) + "/../../jars/simple-spreadsheet-extractor-#{JAR_VERSION}.jar"
    BUFFER_SIZE=250000 # 1/4 a megabyte

    def initialize(memory_allocation)
      @memory_allocation = memory_allocation
      if is_windows?
        raise Exception.new("Windows is not currently supported")
      end
    end

    # can be an IO object or a file path
    def spreadsheet_to_xml(spreadsheet_data)
      if spreadsheet_data.kind_of?(IO) || spreadsheet_data.kind_of?(StringIO)
        Tempfile.create('spreadsheet-extraction') do |f|
          f.write(spreadsheet_data.read)
          f.flush
          read_with_open4 f.path,"xml"
        end
      elsif spreadsheet_data.is_a?(String)
        read_with_open4 spreadsheet_data,"xml"
      end
    end

    # can be an IO object or a file path
    def spreadsheet_to_csv(spreadsheet_data,sheet=1,trim=false)
      if spreadsheet_data.kind_of?(IO) || spreadsheet_data.kind_of?(StringIO)
        Tempfile.create('spreadsheet-extraction') do |f|
          f.write(spreadsheet_data.read)
          f.flush
          read_with_open4 f.path,"csv",sheet,trim
        end
      elsif spreadsheet_data.is_a?(String)
        read_with_open4 spreadsheet_data,"csv",sheet,trim
      end
    end

    private

    def spreadsheet_extractor_command(filepath, format="xml",sheet=nil,trim=false)
      command = "java -Xmx#{@memory_allocation} -jar #{(defined? SPREADSHEET_EXTRACTOR_JAR_PATH) ? SPREADSHEET_EXTRACTOR_JAR_PATH : DEFAULT_PATH}"
      command +=  " -o #{format}"
      command += " -s #{sheet}" if sheet
      command += " -t" if trim
      command += " < #{filepath}"
      command
    end

    def is_windows?
      !(RUBY_PLATFORM =~ /mswin32/ || RUBY_PLATFORM =~ /mingw32/).nil?
    end

    def read_with_open4(filepath,format="xml",sheet=nil,trim=false)
      output = ""
      err_message = ""
      command = spreadsheet_extractor_command filepath, format,sheet,trim
      status = Open4.popen4(command) do |_pid, stdin, stdout, stderr|

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
