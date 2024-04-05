#!/bin/bash
set -eu  # Exit on error

storage_dir=$1
librispeech_dir=$storage_dir/LibriSpeech
librimix_outdir=$storage_dir/


function LibriSpeech_test_clean() {
	if ! test -e $librispeech_dir/test-clean; then
		echo "Download LibriSpeech/test-clean into $storage_dir"
		# If downloading stalls for more than 20s, relaunch from previous state.
		wget -c --tries=0 --read-timeout=20 http://www.openslr.org/resources/12/test-clean.tar.gz -P $storage_dir
		tar -xzf $storage_dir/test-clean.tar.gz -C $storage_dir
		rm -rf $storage_dir/test-clean.tar.gz
	fi
}

LibriSpeech_test_clean 
wait

# Path to python
python_path=python

# Generate LibriMix dataset for 2 speakers
for n_src in 2; do
  metadata_dir=metadata/Libri$n_src"Mix"
  $python_path scripts/create_librimix_from_metadata.py --librispeech_dir $librispeech_dir \
    --metadata_dir $metadata_dir \
    --librimix_outdir $librimix_outdir \
    --n_src $n_src \
    --freqs 8k 16k \
    --modes min max \
    --types mix_clean 
done
