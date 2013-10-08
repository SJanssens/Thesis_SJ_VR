#/bin/bash

input_dir=/esat/spchtemp/scratch/jgemmeke/databases/ALADIN/patience/segmentatie/output/
current_dir=`pwd`
output_dir=../flists/
output_dir=${current_dir}/${output_dir}

# --- per speaker filelist ----

for i in {1..10}
do
	# go to proper dir so those dirnames dont end up in the find output
	cd ${input_dir}/pp$i

	# do a find of all subdirs of this speaker
	# use sed to remove the _audio.wav trailing name (add later in matlab code)
	# use sort to first sort by data (top-dir), and then by move
	find * -name '*audio.wav' | sed 's/..........$//' | sort -t "_" -k1n -k2n > ${output_dir}/pp$i.txt
done

# --- train/testset (first  game (dirs) is train, rest is test ---

# train
for i in {1..10}
do
	# go to proper dir so those dirnames dont end up in the find output
	cd ${input_dir}/pp$i

	# get first dir only
	target_dir=`ls |  sort -n | head -n1`

	# do a find of the first subdir of this speaker
	# use sed to remove the _audio.wav trailing name (add later in matlab code)
	# use sort to first sort by data (top-dir), and then by move
	find ${target_dir}/* -name '*audio.wav' | sed 's/..........$//' | sort -t "_" -k1n -k2n > ${output_dir}/train_pp$i.txt

	# get the rest of the dirs
	target_dir=`ls |  sort -n | tail -n +2`

	# make sure target file is empty
	# loop over the remaining dirs
	# do a find of each subdir
	# use sed to remove the _audio.wav trailing name (add later in matlab code)
	# use sort by move
	# append to test file
	
	: > ${output_dir}/test_pp$i.txt
	for dirname in ${target_dir}
	do
		find ${dirname}/* -name '*audio.wav' | sed 's/..........$//' | sort -t "_" -k2n >> ${output_dir}/test_pp$i.txt
	done

done

# --- remove selected moves due to nonsensical content ---
#remove_file=/esat/spchtemp/scratch/jgemmeke/SVN/ALADIN/databases/patience/annotaties/verwijderde_uitingen.txt
#remove_file=/esat/spchtemp/scratch/jgemmeke/SVN/ALADIN/databases/patience/annotaties/verwijderde_uitingen_jort.txt
#remove_file=/esat/spchtemp/scratch/jgemmeke/SVN/ALADIN/databases/patience/annotaties/verwijderde_uitingen_120127_compl.txt
remove_file=/esat/spchtemp/scratch/jgemmeke/SVN/ALADIN/databases/patience/annotaties/verwijderde_uitingen_120313.txt

tempremove_file=`mktemp`
tempflist_file=`mktemp`

# extract only the lines specifying which commands need to be removed
cat ${remove_file} | grep \# | awk '{ print $3 }' > ${tempremove_file}

# get rid of window-based carriage returns
sed -i -e 's/\r//g' ${tempremove_file}

for i in {1..10}
do
	while read line; do 
		grep -v $line ${output_dir}/pp$i.txt > ${tempflist_file}
		mv ${tempflist_file} ${output_dir}/pp$i.txt

		grep -v $line ${output_dir}/train_pp$i.txt > ${tempflist_file}
		mv ${tempflist_file} ${output_dir}/train_pp$i.txt

		grep -v $line ${output_dir}/test_pp$i.txt > ${tempflist_file}
		mv ${tempflist_file} ${output_dir}/test_pp$i.txt
		
	done < ${tempremove_file}

done
