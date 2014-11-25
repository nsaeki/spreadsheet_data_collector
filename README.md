# spreadsheet_data_collector

Simple data collector which uploads TSV formatted data files to Google Spreadsheet.

## Usage

See [Installation](#installation) how to set up the collector.

In the next example, `path/to/your_project` is your own project that creates daily report data into `data` directory as `data/YYYYMMDD.tsv`.

Create `.spreadsheet_report.yml` in your project directory.

```yaml
---
# spreadsheet_key will be found in the spreadsheet URL
spreadsheet_key: YOUR_GOOGLE_SPREADSHEET_KEY
sheet_name: YOUR_SHEET_NAME

# Data directory which directly includes TSV files.
# This is a relative path from your project root.
directory: data

# OPTIONAL
# The collector regards the first line of TSV file as column names.
# If your TSVs doesn't inclueds header, write column names as an array.
columns:
  - col1
  - col2
  - col3
```

Test:

```bash
$ bundle exec ./collect_data.rb -t path/to/your_project
```

If everything is okey, execute without `-t`

```bash
$ bundle exec ./collect_data.rb path/to/your_project
```

Confirm TSV data is written in the last row of your sheet.
(If not, check your sheet's first line matches column names in TSV in any order.)

You can add other targets in the same way.

## Installation

### Get Google Drive API key

- Create a project in [Google Developers Console](https://console.developers.google.com/).
- Make Google Drive API available in API Section.
- Get OAuth key for an native application.
- Download application secret JSON file.

### Setting up the repository

- Clone this repository.
- `cd` and `bundle install`
- Copy above JSON file as `.credentials.json` in root directory.
- Test Spreadsheet API conection

```bash
$ bundle exec ./collect_data.rb -t    # -t means test-run
```

Shows up an URL to authorize API access from this script, open that in your browser.
And enter your access code printed in the authorized page.

If authorization succeeded, Acquired token will be saved in `.token.yml` file.

## See also
- [Google Sheets API (Working with list-based feeds)](https://developers.google.com/google-apps/spreadsheets/#working_with_list-based_feeds)
