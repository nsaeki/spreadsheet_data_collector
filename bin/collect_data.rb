#!/usr/bin/env ruby
require 'optparse'
require_relative '../lib/spreadsheet_data_collector'

TOKEN_FILE = File.expand_path('../../.token.yml', __FILE__)
CREDS_FILE = File.expand_path('../../.credentials.json', __FILE__)

def usage
  puts <<-EOS.gsub(/^\s*\|/, '')
          |
          |Usage: #{__FILE__} [-t] target_dirs...
          |
          |  target_dir(s) : Upload target directory.
          |                  (That contains spreadsheet_report.yml file in root directory)
          |
          |  -t : Test run. Check spreadsheet connection and display worksheets.
          |       (does not upload any data)
          EOS
end

if __FILE__ == $0
  options = {}
  OptionParser.new(ARGV) do |opts|
    opts.banner = "#{__FILE__} #{SpreadsheetDataCollector::VERSION}"
    opts.on('-a', '--all')   { options[:all_files] = true }
    opts.on('-t', '--test')  { options[:test_run] = options[:debug] = true }
    opts.on('-d', '--debug') { options[:debug] = true }
    opts.on('-h', '--help') do
      usage
      exit
    end
  end.parse!

  if ARGV.empty? && !options[:test_run]
    usage
    exit(1)
  end

  SpreadsheetDataCollector.new(TOKEN_FILE, CREDS_FILE).run(*ARGV)
end
