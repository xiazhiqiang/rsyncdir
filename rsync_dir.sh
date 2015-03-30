#!/bin/bash

dir=$HOME/work/rsyncdir
logfile=$dir/log/`date +%Y%m%d`

# include config file
source $dir/rsync_config.sh

slave_server_len=${#slave_server[*]}

# pull templates
for (( i = 0; i < $slave_server_len; i++ )); do
	rsync -auzv --timeout=30 -e ssh ${slave_server[$i]}:${slave_rsync_dir[$i]}/ ${master_rsync_dir}/

	if [[ $? -eq 0 ]]; then
		echo "pull templates: ${slave_server[$i]}:${slave_rsync_dir[$i]} -> ${master_rsync_dir} :success `date +%Y%m%d%H%M%S`" >> $logfile
	else
		echo "pull templates: ${slave_server[$i]}:${slave_rsync_dir[$i]} -> ${master_rsync_dir} :error `date +%Y%m%d%H%M%S`" >> $logfile
	fi
done

# push templates
for (( i = 0; i < $slave_server_len; i++ )); do
	rsync -avz --delete --timeout=30 -e ssh ${master_rsync_dir}/ ${slave_server[$i]}:${slave_rsync_dir[$i]}/

	if [[ $? -eq 0 ]]; then
		echo "push templates: ${master_rsync_dir} -> ${slave_server[$i]}:${slave_rsync_dir[$i]} :success `date +%Y%m%d%H%M%S`" >> $logfile
	else
		echo "push templates: ${master_rsync_dir} -> ${slave_server[$i]}:${slave_rsync_dir[$i]} :error `date +%Y%m%d%H%M%S`" >> $logfile
	fi
done

exit 0
