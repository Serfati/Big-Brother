#!/bin/bash
dir=$1
# if its the second time or above to run the script, we compare and organize the changes in reference files
if [ -f $dir/old_file.txt ]; then
	ls -ltr $dir > $dir/new_file.txt
	grep -Fxvf $dir/new_file.txt $dir/old_file.txt | awk '{for(i=9; i<=NF; ++i) printf $i""FS; print""}' >> $dir/del.txt
	grep -Fxvf $dir/old_file.txt $dir/new_file.txt | grep ^d | awk '{for(i=9; i<=NF; ++i) printf $i""FS; print""}' >> $dir/add_d.txt
	grep -Fxvf $dir/old_file.txt $dir/new_file.txt | grep -v ^d | awk '{for(i=9; i<=NF; ++i) printf $i""FS; print""}'  >> $dir/add_f.txt

	
	# here we print each reference file, and filter out irrelevant row(s) in it  

	
	if [ -f $dir/del.txt ]; then	
		cat $dir/del.txt | grep -v "old_file.txt" | grep -v '^$' | while read line; do
    			echo "File deleted: $line"
		done	
	fi
	if [ -f $dir/add_f.txt ]; then
                cat $dir/add_f.txt | grep -v "new_file.txt" | grep -v "old_file.txt" | grep -v '^$'| while read line; do
                        echo "File created: $line"
                done
        fi
	if [ -f $dir/add_d.txt ]; then
		cat $dir/add_d.txt | grep -v '^$' | while read line; do
			echo "Folder created: $line"
		done
	fi

        # remove the reference files and	
	# update the new file to be the old one for the next time
	rm $dir/new_file.txt $dir/del.txt $dir/add_d.txt $dir/add_f.txt
	ls -ltr $dir > $dir/old_file.txt

#if its the first time to run script in folder
else
	echo "Welcome to the Big Brother"
	ls -ltr $dir > $dir/old_file.txt
fi
