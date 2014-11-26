#!/usr/bin/env ruby
require 'optparse'
require_relative '../lib/spreadsheet_data_collector'

PROGRAM_NAME = 'spreadsheet_data_collector'
TOKEN_FILE = File.expand_path('../../.token.yml', __FILE__)
CREDS_FILE = File.expand_path('../../.credentials.json', __FILE__)

def usage
  puts <<-EOS.gsub(/^\s*\|/, '')
          |
          |Usage: #{__FILE__} target_dirs...
          |
          |  target_dir(s) : Collect data files in the directory.
          |                  (`.spreadsheet_report.yml` file resides in the directory)
          |
          |  -t : Test run. Check spreadsheet connection and display worksheets.
          |       (does not upload any data)
          |  -h : This help.
          |
          |#{PROGRAM_NAME} v#{SpreadsheetDataCollector::VERSION}
          EOS
end

if __FILE__ == $0
  options = {}
  OptionParser.new(ARGV) do |opts|
    # Public options.
    opts.on('-t', '--test')  { options[:test_run] = options[:debug] = true }
    opts.on('-h', '--help') do
      usage
      exit
    end

    # For private use. Incompatible changes will occur in future.
    opts.on('-a', '--all')   { options[:all_files] = true }
    opts.on('-d', '--debug') { options[:debug] = true }

  end.parse!

  if ARGV.empty? && !options[:test_run]
    usage
    exit(1)
  end

  SpreadsheetDataCollector.new(TOKEN_FILE, CREDS_FILE, options).run(*ARGV)
end
