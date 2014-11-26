#!/bin/sh
# Sample script to run collector as daily cron.
# Set up this like this:
# 0 4 * * * /path/to/this/repo/util/cron.sh

cd `dirname $0`/..
bundle exec bin/collect_data.rb target/*
