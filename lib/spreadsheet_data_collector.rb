# coding: utf-8
require 'logger'
require 'yaml'
require 'json'
require 'google_spreadsheet_recorder'

class SpreadsheetDataCollector
  VERSION = '0.0.1'
  DEFAULT_OPTIONS = {
    all_files: false,
    debug: false,
    test_run: false
  }

  CONFIG_YAML = '.spreadsheet_report.yml'
  DEFAULT_CONFIG = {
    'ignore_files_before' => 24 * 60 * 60, # in seconds
  }

  def initialize(token_file, creds_file, options = {})
    @token_file   = token_file
    @creds        = JSON.parse(IO.read(creds_file))
    @options      = DEFAULT_OPTIONS.merge(options)
    @spreadsheet  = GoogleSpreadsheetRecorder.new(@creds['installed']['client_id'],
                                                  @creds['installed']['client_secret'],
                                                  @token_file)
    @logger       = Logger.new($stdout)
    @logger.level = @options[:debug] ? Logger::DEBUG : Logger::INFO
  end

  def run(*dirs)
    dirs.each { |d| collect_data(d) }
  end

  private

  def collect_data(dir)
    config = load_config(dir)
    @spreadsheet.spreadsheet_key = config['spreadsheet_key']
    sheet_id = worksheet_id(config['sheet_name'])

    if sheet_id.nil?
      raise ArgumentError, "Could not find worksheet in spreadsheet: #{config['sheet_name']}"
    end

    ignore_before = Time.now - config['ignore_files_before']

    Dir.glob(File.join(dir, config['directory'], "*")) do |file|
      if !@options[:all_files] && File.mtime(file) < ignore_before
        @logger.debug("Skip old file: #{file}")
        next
      end
      record_to_spreadsheet(sheet_id, config, file)
    end
  end

  def load_config(dir)
    config_file = File.join(dir, CONFIG_YAML)
    unless File.exists?(config_file)
      @logger.warn("File not found: #{config_file}")
      @logger.warn("Skip directory: #{dir}")
      return
    end

    DEFAULT_CONFIG.merge(YAML.load_file(config_file))
  end

  # returns sheet_id
  # TODO: this method should be in the GoogleSpreadsheetReporter.
  def worksheet_id(sheet_name)
    @spreadsheet.worksheets.tap { |sheets|
      @logger.debug("==== Worksheets ====")
      @logger.debug([' [Sheet Name]', '[Sheet ID]'].join("  "))
      sheets.each { |x| @logger.debug(x.join("  ")) }
    }.each { |sheet|
      return sheet[1] if sheet[0] == sheet_name
    }
  end

  def record_to_spreadsheet(sheet_id, config, data_file)
    @logger.info("Upload file: #{data_file} into worksheet: #{config['sheet_name']}")
    lines = IO.readlines(data_file)
    columns = config['columns'] || lines.shift.strip.split("\t")

    rows = lines.map do |line|
      Hash[columns.zip(line.strip.split("\t"))]
    end

    dry_run_mark = @options[:test_run] ? "[DRY RUN] " : ""
    Array(rows).each do |row|
      log_mesg = "#{dry_run_mark}Sending #{row}"
      @logger.debug(log_mesg)
      @spreadsheet.send_row(row, sheet_id) unless @options[:test_run]
    end
  end
end
