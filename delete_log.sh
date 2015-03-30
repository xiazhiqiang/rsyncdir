#!/bin/bash

dir=$HOME/work/rsyncdir
# delete log files that were 10 days ago
find $dir/log/ -mtime +10 -type f -name "[0-9]*" | xargs rm -rf