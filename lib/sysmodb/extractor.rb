require 'terrapin'

module SysMODB
  # Exception that is thrown when a problem occurs during the extraction
  class SpreadsheetExtractionException < Exception; end

  # handles the delegation to java
  class Extractor
    JAR_VERSION = '0.18.1'.freeze
    DEFAULT_PATH = File.dirname(__FILE__) + "/../../jars/simple-spreadsheet-extractor-#{JAR_VERSION}.jar"

    def initialize(memory_allocation)
      @memory_allocation = memory_allocation
      raise Exception, 'Windows is not currently supported' if is_windows?
    end

    # spreadsheet_data can be an IO like object or the path to a file
    def spreadsheet_to_xml(spreadsheet_data)
      spreadsheet_to_requested_format(spreadsheet_data, 'xml')
    end

    # spreadsheet_data can be an IO like object or the path to a file
    def spreadsheet_to_csv(spreadsheet_data, sheet = 1, trim = false)
      spreadsheet_to_requested_format(spreadsheet_data, 'csv', sheet, trim)
    end

    private

    def spreadsheet_to_requested_format(spreadsheet_data, format, sheet = nil, trim = nil)
      if spreadsheet_data.is_a?(IO) || spreadsheet_data.is_a?(StringIO)
        Tempfile.create('spreadsheet-extraction') do |f|
          f.write(spreadsheet_data.read)
          f.flush
          execute_command_line f.path, format, sheet, trim
        end
      elsif spreadsheet_data.is_a?(String)
        execute_command_line spreadsheet_data, format, sheet, trim
      end
    end

    def spreadsheet_extractor_command_line(filepath, format = 'xml', sheet = false, trim = false)

      args  = "-Xmx#{@memory_allocation} -jar #{(defined? SPREADSHEET_EXTRACTOR_JAR_PATH) ? SPREADSHEET_EXTRACTOR_JAR_PATH : DEFAULT_PATH}"
      args += " -o :format"
      args += " -s :sheet" if sheet
      args += ' -t' if trim
      args += " < :filepath"
      args += " 2>:error_log_path"
      Terrapin::CommandLine.new("java", args)
    end

    def is_windows?
      !(RUBY_PLATFORM =~ /mswin32/ || RUBY_PLATFORM =~ /mingw32/).nil?
    end

    def execute_command_line(filepath, format = 'xml', sheet = nil, trim = false)
      command_line = spreadsheet_extractor_command_line filepath, format, !!sheet, trim
      Tempfile.create('spreadsheet-extraction-error-log') do |f|
        begin
          command_line.run(format: format, sheet: sheet, filepath: filepath, error_log_path: f.path).strip
        rescue Terrapin::ExitStatusError, Terrapin::CommandNotFoundError
          raise SpreadsheetExtractionException, f.read
        end
      end
    end

  end
end
