# Simple data collector to Google Spreadsheet

This is a simple script to collect TSV-formatted files and record in your Google Spreadsheet as new lines.

## Installation

### Getting Google Drive API key

- Create a project at [Google Developers Console](https://console.developers.google.com/).
- Make Google Drive API available in API Section.
- Get OAuth key for an native application.
- Save secret JSON file.

### Setting up the repository

- Clone this repository.
- cd and `bundle install`
- Put above `.credentials.json` file in root directory of the repository.
- Test Spreadsheet API conection

```bash
$ bundle exec ./collect_data.rb -t    # -t means test-run
```

Shows up an URL to authorize API access from this script, open that in your browser.
And enter your access code printed in the authorized page.

If authorization succeeded, Acquired token will be saved in `.token.yml` file.

### Adding your data collection directory

Create `.spreadsheet_report.yml` in your work directory.

```yaml
---
spreadsheet_key: YOUR_GOOGLE_SPREADSHEET_KEY
sheet_name: YOUR_SHEET_NAME

# Relative path from this YAML file to data diretory
# which contains TSV files directly.
directory: path/to/directory

# OPTIONAL
# If your tsv does not contains column header in first line,
# write column name as an array.
columns:
  - col1
  - col2
  - col3
```

Create symbolic link to target directory in `reports` directory.

```bash
$ ln -s path/to/your_project target/
```

And run:

```bash
$ bundle exec ./collect_data.rb -t target/your_project
```
Prints collected files and record to upload. (Files updated within a day will be collected)
If that's OK, execute without `-t`:

```bash
$ bundle exec ./collect_data.rb target/your_project
```

This writes results in the last row of your sheet.

You can add other targets in the same way.

## See also
- Google Sheets API (Working with list-based feeds)

https://developers.google.com/google-apps/spreadsheets/#working_with_list-based_feeds

